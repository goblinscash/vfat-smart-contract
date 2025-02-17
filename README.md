### base sepolia testnet deployed addresses

```
UniswapV3Connector : 0x5d6094F3d68d725153d0938ce5b0E4D7815B42A7
AerodromeRouterConnector : 0x43FDB828aD3D705Fc5D25467f078a724fC209c5D

NftFarmStrategy: 0xE174bB384365CBD50BF50E8dEeA7DF8b8808dfac

SickleImplementation: 0x527A36c3C0e66d10664954cd86B156670e6871E0
SickleFactory: 0x62fB598f4a7379Ca36c2d031443F6c97B8F60C3f
NftSettingsRegistry: 0xcec6e003108B15FA31A7F5BD80f91aAab3E565CF

SickleRegistry: 0xFd8E0705EdCc01A142ed0a8e76F036e38B72Bcc3
ConnectorRegistry: 0xdBaE2aA28b83b952f7542F87420897F4e12F1A99
SickleFactory: 0x62fB598f4a7379Ca36c2d031443F6c97B8F60C3f

NftTransferLib : 0xa2C3056E4150A9Df0459FEd70Bc735702dC6Cc30
NftSettingsLib: 0x4FDAd64621cd20CCC94164bF81C299ff75346E6a
FeesLib: 0x2c2fC8A1CDa7d853a214e294ea40De03d9fC1d2D
TransferLib: 0x64e72a67eaE17aa771D97eA07e3407b171f33Fe5
SwapLib: 0xd98634607C1FEc0dfB925c64037a675eb17a2fc2
NftZapLib: 0x758a3B49A4Fee14B18CC8dFA5CeB547Acc594f21

```

```
usdt : 0x86509bA8e6F823b77Fc5E705F8e352Acb497C900

```

### base mainnet deployed addresses

```
NftSettingsLib: 0x993A70694594B40b6fBa8Bd228111705e5af32fa
NftTransferLib: 0x359A5f4AD8A13cfad7b7C9459929AEDba930BBa8
FeesLib: 0x39318fea5B43BE55615c8c2fa9Ac3913425a8A74
TransferLib: 0x20fd03a19Fa0c45f54b8Cc2a0781B10CcE6A1936
SwapLib: 0x98dc8aC4a5AcCbc17bBd91E8cFceb9fc2F317802
NftZapLib: 0x335f82f20E33400258a1cd235bEC4D6B8E601796

SickleRegistry: 0xF1Cf2598d89215d15578813aBc04698BB55b8E3F
ConnectionRegistry: 0x7d540FC712004c30A288962abAc7b47A86907734
NftSettingsRegistry: 0x7e8CfE955e6C747FD3Cd34361410d0933558ff16
SickleFactory: 0x52FFaccCBC6B6854Dd639D31b524CFe7485C8e67

Sickle: 0x72a72C80fe211bEaBce5516974fffa2c9aECBb3D

NftFarmStrategy: 0x63B7CB79f503cB9BB154DD3bfFC1095edb272df3
UniswapV3Connector: 0x5d53c9614C9054E622b1eA35231cEc2049A3a44e
```

### Sickle Registry
```
1. whitelist uniswapV3Connector in SickleRegistry
2. whitelist settingLib in Sickle Registry
3. whitelist FeesLib in Sickle Registry
4. whitelist NftSettingLib in Sickle Registry
5. whitelist NftFarmStrategy in Sickle Registry
6. whitelist NftZapLib in Sickle Registry
7. whitelist TransferLib in Sickle Registry
```




forge script script/UniswapV3Connector.s.sol:UniswapV3ConnectorScript --broadcast --rpc-url https://mainnet.base.org --private-key 



forge script script/NftFarmStrategy.s.sol:NftFarmStrategyScript --broadcast --rpc-url https://mainnet.base.org --private-key 


forge verify-contract --rpc-url https://mainnet.base.org 0x5d53c9614C9054E622b1eA35231cEc2049A3a44e UniswapV3Connector --verifier-api-key 5IXHGRSRBJAUG5URPDJXPV6DPMSY648UK8



forge verify-contract \
  --rpc-url https://mainnet.base.org \
  0x52FFaccCBC6B6854Dd639D31b524CFe7485C8e67 \
  SickleFactory \
  --constructor-args $(cast abi-encode "constructor(address,address,address,address)" \
  "0x9009a3BffFe89419D7dA4E6740ABdFE3b1BA843c" \
  "0xF1Cf2598d89215d15578813aBc04698BB55b8E3F" \
  "0x72a72C80fe211bEaBce5516974fffa2c9aECBb3D" \
  "0x0000000000000000000000000000000000000000") \
  --verifier-api-key 5IXHGRSRBJAUG5URPDJXPV6DPMSY648UK8




forge verify-contract \
  --rpc-url https://base-sepolia-rpc.publicnode.com \
  0xFd8E0705EdCc01A142ed0a8e76F036e38B72Bcc3 \
  NftSettingsRegistry \
  --constructor-args $(cast abi-encode "constructor(address,address, address, address)" 
  "0xe47C11e16783eE272117f8959dF3ceEC606C045d"
  "0xFd8E0705EdCc01A142ed0a8e76F036e38B72Bcc3"
   "0x527A36c3C0e66d10664954cd86B156670e6871E0"
   "0x0000000000000000000000000000000000000000"
   ) \
  --verifier-api-key 5IXHGRSRBJAUG5URPDJXPV6DPMSY648UK8


  forge verify-contract \
  --rpc-url https://base-sepolia-rpc.publicnode.com \
  0xcec6e003108B15FA31A7F5BD80f91aAab3E565CF \
  NftFarmStrategy \
  --constructor-args $(cast abi-encode "constructor(address)" "0x62fB598f4a7379Ca36c2d031443F6c97B8F60C3f") \
  --verifier-api-key 5IXHGRSRBJAUG5URPDJXPV6DPMSY648UK8


  forge verify-contract \
  --rpc-url https://mainnet.base.org \
  0x63B7CB79f503cB9BB154DD3bfFC1095edb272df3 \
  NftFarmStrategy \
  --constructor-args $(cast abi-encode "constructor(address,address,address,(address,address,address,address,address,address))" "0x52FFaccCBC6B6854Dd639D31b524CFe7485C8e67" "0x7d540FC712004c30A288962abAc7b47A86907734" "0x7e8CfE955e6C747FD3Cd34361410d0933558ff16" "(0x359A5f4AD8A13cfad7b7C9459929AEDba930BBa8,0x20fd03a19Fa0c45f54b8Cc2a0781B10CcE6A1936,0x98dc8aC4a5AcCbc17bBd91E8cFceb9fc2F317802,0x39318fea5B43BE55615c8c2fa9Ac3913425a8A74,0x335f82f20E33400258a1cd235bEC4D6B8E601796,0x993A70694594B40b6fBa8Bd228111705e5af32fa)") \
  --verifier-api-key 5IXHGRSRBJAUG5URPDJXPV6DPMSY648UK8


