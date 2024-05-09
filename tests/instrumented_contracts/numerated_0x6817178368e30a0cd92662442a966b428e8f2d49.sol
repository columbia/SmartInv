1 pragma solidity ^0.4.0;
2 contract theCyberGatekeeper {
3   function enter(bytes32 _passcode, bytes8 _gateKey) public {}
4 }
5 
6 contract GateProxy {
7     function enter(bytes32 _passcode, bytes8 _gateKey) public {
8         theCyberGatekeeper(0x44919b8026f38D70437A8eB3BE47B06aB1c3E4Bf).enter.gas(81910)(_passcode, _gateKey);
9     }
10 }