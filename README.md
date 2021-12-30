# VGSCollect-ios

## Table of contents
- [Overview](#overview)
- [Getting started](#getting-started)
- [Parameters](#parameters)
- [Tooling](#tooling)
- [API Reference](#api-reference)
- [Packages](#third-party-libraries)


## Overview
Using VGSCollect sdk we can set a pin for the cards

## Getting started
Configure VGSCollect Sample :
- Clone respository
```groovy
git clone git@github.com:solidfi/vgs-collect-ios.git
OR
git clone https://github.com/solidfi/vgs-collect-ios.git
```
- Open project and run in Simulator
```groovy
1. Launch `Xcode` and open the project `vgsCollect/vgsCollect.xcodeproj`
2. Run in Simulator
```

## Parameters

In order to start the project we need below parameters. All fields are mendatory

VGSVaultID : Talk to our solutions team (solutions@solidfi.com) to get the ID via a secured method. (It will different base on sandbox          and live)
CardID : Id of your card
CardToken : You will get it from the "pintoken" api from the backend
Environment :  Select live or sandbox environment
Last4CardDigit : Last 4 didit of card number
ExpMonth : Expiry month (MM) of the card
ExpYear : Expiry year (YYYY) of the card
4DigitPin : Pin you want to set for the card (It should be numeric)

Notes: CardToken can be used only once to set pin. You need to call "pintoken" api to generate new CardToken    

## Tooling
- iOS 13.0 +
- Xcode 11 +
- Swift 5.0 +

## API Reference
- VGS Collect Integration : https://www.verygoodsecurity.com/docs/vgs-collect/ios-sdk/integration
- Solid API Integration : https://documenter.getpostman.com/view/13543869/TWDfEDwX#ce8c0e57-0dcf-45ea-87d8-6f03a302e027

## Packages
- VGSShowSDK
- VGSCollectSDK
- IQKeyboardManager
- MBProgressHUD
