---
name: unity-litmotion
description: LitMotion high-performance zero-allocation tweening library for Unity (tween, animation, UI transition, LMotion, LSequence, Punch, Shake, BindToPosition, BindToLocalScale, BindToColor, ToUniTask). Use when creating animations, UI transitions, procedural motion, or replacing DOTween in Unity.
---

# LitMotion — Zero-Allocation Tweening for Unity

## Overview

**LitMotion** (by AnnulusGames) is an ultra-fast, zero-allocation tweening library for Unity built on DOTS (Burst Compiler & C# Job System). Always use **LitMotion** instead of DOTween or legacy coroutines for procedural animations and UI transitions.

## Installation & Namespaces

```csharp
using LitMotion;
using LitMotion.Extensions; // Required for .BindToPosition(), .BindToColor(), etc.
using Cysharp.Threading.Tasks; // Optional: for .ToUniTask() integration
```

---

## Core Rules (Mandatory)

1. **Zero-Allocation Binding**: Always use `LitMotion.Extensions` methods (`.BindToPosition()`, `.BindToLocalScale()`, `.BindToAlpha()`, etc.) or `.BindWithState(target, (val, state) => ...)` instead of capturing variables in a standard `.Bind(x => ...)` closure when in hot paths.
2. **Lifecycle Management**: **Never** leave a motion handle unmanaged. Always bind its lifetime using `.AddTo(gameObject)` / `.AddTo(this)`, store the `MotionHandle` to call `handle.TryCancel()`, or group handles in a `CompositeMotionHandle`.
3. **UniTask Integration**: When sequencing gameplay or UI flows asynchronously, convert the `MotionHandle` using `await handle.ToUniTask(cancellationToken: destroyCancellationToken);`.
4. **Never use DOTween syntax** (`transform.DOMove`, `Sequence.Append`) in projects standardized on LitMotion.

---

## Basic Motion Patterns

### Transform & RectTransform Animations

```csharp
using LitMotion;
using LitMotion.Extensions;
using UnityEngine;

public class UIPopupAnimator : MonoBehaviour
{
    [SerializeField] private RectTransform _panel;
    [SerializeField] private CanvasGroup _canvasGroup;

    public void ShowPopup()
    {
        // Scale punch / pop-in
        _panel.localScale = Vector3.one * 0.8f;
        LMotion.Create(Vector3.one * 0.8f, Vector3.one, 0.25f)
            .WithEase(Ease.OutBack)
            .BindToLocalScale(_panel)
            .AddTo(this);

        // Fade in CanvasGroup
        _canvasGroup.alpha = 0f;
        LMotion.Create(0f, 1f, 0.2f)
            .WithEase(Ease.OutQuad)
            .BindToAlpha(_canvasGroup)
            .AddTo(this);
    }
}
```

### Common Extension Binders (`LitMotion.Extensions`)

```csharp
// Transform
LMotion.Create(from, to, duration).BindToPosition(transform);
LMotion.Create(from, to, duration).BindToLocalPosition(transform);
LMotion.Create(from, to, duration).BindToPositionX(transform); // Also Y, Z
LMotion.Create(from, to, duration).BindToLocalEulerAngles(transform);
LMotion.Create(from, to, duration).BindToLocalScale(transform);

// RectTransform (uGUI)
LMotion.Create(from, to, duration).BindToAnchoredPosition(rectTransform);
LMotion.Create(from, to, duration).BindToSizeDelta(rectTransform);

// UI Graphic / SpriteRenderer / CanvasGroup
LMotion.Create(fromColor, toColor, duration).BindToColor(image);
LMotion.Create(0f, 1f, duration).BindToAlpha(canvasGroup);
LMotion.Create(0f, 1f, duration).BindToFillAmount(image);

// Audio
LMotion.Create(1f, 0f, duration).BindToVolume(audioSource);
LMotion.Create(1f, 1.5f, duration).BindToPitch(audioSource);
```

---

## Zero-Allocation Custom Binding (`BindWithState`)

When animating custom properties without a built-in `BindTo*` extension, avoid lambda closures:

```csharp
// BAD: Allocates a closure on the heap every time this method runs
LMotion.Create(0f, 100f, 1f)
    .Bind(val => _myCustomComponent.Progress = val);

// GOOD: Zero allocation by passing the target state explicitly
LMotion.Create(0f, 100f, 1f)
    .BindWithState(_myCustomComponent, static (val, target) =>
    {
        target.Progress = val;
    })
    .AddTo(this);
```

---

## Punch, Shake & String Animations

### Punch & Shake (Hit Reactions, Camera Shake, UI Error)

```csharp
// Punch (oscillates around start value and settles back to start)
LMotion.Punch.Create(start: Vector3.zero, strength: new Vector3(15f, 0f, 0f), duration: 0.4f)
    .WithFrequency(10)
    .WithDampingRatio(0.5f)
    .BindToAnchoredPosition(errorInputRect)
    .AddTo(this);

// Shake (random vibration around start value)
LMotion.Shake.Create(start: transform.localPosition, strength: Vector3.one * 0.2f, duration: 0.3f)
    .WithFrequency(20)
    .BindToLocalPosition(transform)
    .AddTo(this);
```

### Zero-Allocation Text / Damage Counter (`LMotion.String`)

```csharp
using TMPro;
using LitMotion;
using LitMotion.Extensions;

// Rolling number counter or typewriter effect without string GC allocations
LMotion.String.Create128Bytes("", "Mission Complete!", 1.5f)
    .WithRichText()
    .WithScrambleChars(ScrambleMode.Uppercase)
    .BindToText(tmpText)
    .AddTo(this);
```

---

## Configuration & Loops (`With*` Modifiers)

```csharp
LMotion.Create(0f, 1f, 0.5f)
    .WithEase(Ease.InOutSine)
    .WithLoops(2, LoopType.Yoyo)           // -1 for infinite loops
    .WithDelay(0.1f, DelayType.FirstLoop)
    .WithScheduler(MotionScheduler.UpdateIgnoreTimeScale) // Run during pause (Time.timeScale == 0)
    .WithOnComplete(() => Debug.Log("Finished!"))
    .WithCancelOnError()
    .BindToAlpha(canvasGroup)
    .AddTo(this);
```

---

## Sequencing (`LSequence`) & UniTask Integration

### Option A: `LSequence` (LitMotion v2+)

```csharp
var handle = LSequence.Create()
    .Append(LMotion.Create(0f, 1f, 0.2f).BindToAlpha(_canvasGroup))
    .Join(LMotion.Create(Vector3.zero, Vector3.one, 0.25f).WithEase(Ease.OutBack).BindToLocalScale(_panel))
    .AppendInterval(0.5f)
    .Append(LMotion.Create(1f, 0f, 0.2f).BindToAlpha(_canvasGroup))
    .Run();

handle.AddTo(this);
```

### Option B: `UniTask` Async Sequencing (Preferred for Gameplay/UI Flows)

```csharp
public async UniTask PlayVictoryTransitionAsync(CancellationToken ct)
{
    // Parallel tweens with UniTask.WhenAll
    await UniTask.WhenAll(
        LMotion.Create(0f, 1f, 0.3f)
            .WithEase(Ease.OutQuad)
            .BindToAlpha(_bannerGroup)
            .ToUniTask(ct),
        LMotion.Create(new Vector2(0, -100f), Vector2.zero, 0.35f)
            .WithEase(Ease.OutBack)
            .BindToAnchoredPosition(_bannerRect)
            .ToUniTask(ct)
    );

    await UniTask.Delay(500, cancellationToken: ct);

    // Sequential fade-out
    await LMotion.Create(1f, 0f, 0.25f)
        .BindToAlpha(_bannerGroup)
        .ToUniTask(ct);
}
```

---

## Managing Handle Lifetimes

### Single Handle Replacement (Prevent Overlapping Tweens)

```csharp
private MotionHandle _moveHandle;

public void MoveTo(Vector3 targetPos)
{
    // Safely cancel previous motion if still active
    if (_moveHandle.IsActive())
    {
        _moveHandle.Cancel();
    }

    _moveHandle = LMotion.Create(transform.position, targetPos, 0.3f)
        .WithEase(Ease.OutCubic)
        .BindToPosition(transform);
}

private void OnDestroy()
{
    if (_moveHandle.IsActive())
    {
        _moveHandle.Cancel();
    }
}
```

### Multiple Handles (`CompositeMotionHandle`)

```csharp
private readonly CompositeMotionHandle _motions = new(capacity: 8);

public void PlayAll()
{
    _motions.Cancel(); // Cancel any active tweens in the group

    LMotion.Create(0f, 1f, 0.3f).BindToAlpha(_group).AddTo(_motions);
    LMotion.Create(Vector3.zero, Vector3.one, 0.3f).BindToLocalScale(_rect).AddTo(_motions);
}

private void OnDestroy()
{
    _motions.Cancel();
}
```
