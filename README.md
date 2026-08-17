# Guildmaster

A small idle-management game developed in **Godot and GDScript over the course of one week** as an experiment in rapidly learning and applying an unfamiliar development environment.

The project was created as a personal challenge: start with limited experience in Godot and GDScript, learn the tools while developing the game, and produce a complete playable project within a strict one-week timeframe.

## Overview

Guildmaster places the player in charge of an adventurer's guild.

Rather than playing as an individual adventurer, the player manages the organisation itself, overseeing its growth and progression. This involves the hiring and firing of adventurers, choosing which assignments / quests to send them on according to each adventurer's abilities, and the spending of the incoming cash flow for upgrades to the guild.

The project was deliberately kept small enough to complete within one week while still providing an opportunity to explore game state, progression systems, user interface design and GDScript development.

## The One-Week Challenge

The primary purpose of Guildmaster was **not simply to create a game**.

It was an experiment in how quickly I could become productive with an unfamiliar technology.

At the beginning of the project, Godot and GDScript were new tools for me. I therefore had to learn the engine and language while simultaneously designing and implementing the game.

The project was completed within approximately **one week**, resulting in a playable game and a working set of core gameplay systems.

This provided practical experience in:

* Rapidly learning unfamiliar technology.
* Translating existing programming knowledge into a new language.
* Learning a new engine's architecture and workflows.
* Making development decisions under a strict time constraint.
* Prioritising features to produce a complete result within the available time.

## Gameplay

Guildmaster is built around an incremental management loop:

```text
Manage Guild
     │
     ▼
Generate Gold & Influence
     │
     ▼
Improve Guild
     │
     ▼
Progress Further
     │
     └──────────────► Repeat
```

The game's design focuses on progression and management rather than traditional direct-control gameplay.

## Features

* Incremental progression loop
* Guild management and progression
* Persistent game state between play sessions, with mechanics tied to real-world time passing even while the game is off.
* Extensive randomisation and variance in heroes, hero abilities, quests and challenges.
* Interactive UI
* Fantasy-themed presentation

## Technical Highlights

### Godot

Guildmaster was developed using the **Godot Engine**, providing hands-on experience with an engine that was unfamiliar at the beginning of the project.

The project involved learning Godot's scene-based architecture, node system, editor workflow and scripting environment while developing the game itself.

### GDScript

Gameplay systems were implemented using **GDScript**.

The project provided an opportunity to transfer existing programming concepts into a new language while learning the conventions and patterns commonly used within Godot.

### Game State & Progression

The game required systems for managing changing player state and progression, including:

* Resources (Gold, Influence)
* Guild Upgrades
* World persistence
* Time-based behaviour
* UI updates based on game state

These systems needed to remain synchronised as the player's guild progressed.

## Technology

* **Godot Engine**
* **GDScript**

## Development Constraints

| Constraint        | Details                                                |
| ----------------- | ------------------------------------------------------ |
| Development time  | Approximately one week                                 |
| Engine            | Godot                                                  |
| Language          | GDScript                                               |
| Primary objective | Learn an unfamiliar tool and produce a playable result |
| Project type      | Personal development challenge                         |

## Demo

The game is currently playable online at https://teasunset.itch.io/guildhall-idle-adventures

## Project Status

**Completed.**

Guildmaster was intentionally developed as a short-term learning challenge rather than as a long-term commercial game.

The project successfully demonstrated that I could become productive with an unfamiliar engine and language within a short timeframe while still delivering a complete playable result.

## What I Learned

The most valuable outcome of Guildmaster was the experience of learning a completely new development environment while simultaneously producing a finished project.

The project provided practical experience with:

* Godot's scene and node architecture.
* GDScript.
* Game state management.
* Incremental progression systems.
* UI-driven gameplay.
* Rapid prototyping.
* Working within strict development constraints.
* Adapting existing programming knowledge to unfamiliar tools.

## Why I Built It

Guildmaster was created as a deliberate test of **technical adaptability**.

Rather than spending weeks becoming familiar with Godot before starting a project, I wanted to see how effectively I could learn by building something immediately.

The result is a small project, but one that demonstrates an ability that is important beyond game development:

> **Given an unfamiliar technology and a limited amount of time, I can learn enough to build something functional with it.**

## Future Development

Guildmaster is considered complete for the purposes of the original one-week challenge.

If development were continued, potential improvements could include:

* Expanded guild management systems--particularly, there was a scrapped, planned equipment system that would be nice to implement.
* Additional random events and gameplay mechanics.
* Expanded content and polish.

---

## Project Context

Guildmaster is a personal programming project created to demonstrate rapid technical learning and adaptability.

It complements my larger software engineering projects by demonstrating experience with **Godot, GDScript, interactive software and game development**, while also showing my ability to work productively with unfamiliar technology under significant time constraints.
