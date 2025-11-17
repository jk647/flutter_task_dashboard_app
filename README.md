# Flutter Provider Task - Dashboard Application

A small Flutter application demonstrating state management using Provider with a clean separation between models, providers (viewmodels) and views.

## 📋 Project Overview

This project implements a two-screen dashboard application that reads items from a local JSON file and allows editing item details using Provider for global state updates.

## ✨ Features

### Screen A - Dashboard (Home Screen)
- Display items from a local JSON file (`assets/data.json`)
- Toggle between Grid and List layouts
- Pull-to-refresh functionality (re-parses the JSON)
- State management with `loading`, `loaded`, and `error` states
- Card-based UI with category badges and price display

### Screen B - Detail Screen
- View full item details
- Edit item fields (title, description, price, category)
- Form validation for inputs
- Updates are applied globally via Provider and reflected on the dashboard
- Save/Cancel (edit toggle) UX with success/error feedback

## 🏗️ Architecture

This project follows a Provider-driven, MVVM-like structure (clear separation of Model, View, and Provider logic):