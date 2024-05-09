1 pragma solidity ^0.4.24;
2 contract EnjoyGameToken {
3     function transfer(address _to, uint256 _value) public returns (bool);
4     function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
5     function transferAndLock(address _to, uint256 _value, uint256 _releaseTimeS) public returns (bool);
6 }
7 contract TransferEGTMulti {
8     address public tokenAddr = 0xc5faadd1206ca91d9f8dd015b3498affad9a58bc;
9     EnjoyGameToken egt = EnjoyGameToken(tokenAddr);
10 
11     modifier isAdmin() {
12         if(0xe7266A1eFb21069E257Ec8Fc3e103f1FcF2C3e5D != msg.sender
13         && 0xc1180dd8a1270c7aafc76d957dbb1c4c09720370 != msg.sender
14         && 0x7C2A9bEA4177606B97bd333836F916ED475bb638 != msg.sender
15         && 0x22B8EAeA7F027c37a968Ac95c7Fa009Aa52fF754 != msg.sender
16         && 0xC24878A818Da47A1f39f2F926620E547B0d41831 != msg.sender){
17             revert("not admin");
18         }
19         _;
20     }
21     function transferMulti(address[] tos, uint256[] values) public isAdmin() {
22         if(tos.length != values.length){
23             revert("params error");
24         }
25         for(uint256 i=0; i<tos.length; i++){
26             egt.transfer(tos[i], values[i]);
27         }
28     }
29     function transferFromMulti(address[] froms, address[] tos, uint256[] values) public isAdmin() {
30         if(tos.length != froms.length || tos.length != values.length){
31             revert("params error");
32         }
33         for(uint256 i=0; i<tos.length; i++){
34             egt.transferFrom(froms[i], tos[i], values[i]);
35         }
36     }
37     function transferAndLockMulti(address[] tos, uint256[] values, uint256[] _releaseTimeSs) public isAdmin() {
38         if(tos.length != values.length || tos.length != _releaseTimeSs.length){
39             revert("params error");
40         }
41         for(uint256 i=0; i<tos.length; i++){
42             egt.transferAndLock(tos[i], values[i], _releaseTimeSs[i]);
43         }
44     }
45 }