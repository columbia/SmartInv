1 pragma solidity ^0.4.11;
2 
3 
4 import '../token/linkERC20.sol';
5 
6 
7 contract LinkReceiver {
8 
9   bool public fallbackCalled;
10   bool public callDataCalled;
11   uint public tokensReceived;
12 
13 
14   function onTokenTransfer(address _from, uint _amount, bytes _data)
15   public returns (bool success) {
16     fallbackCalled = true;
17     if (_data.length > 0) {
18       require(address(this).delegatecall(_data, msg.sender, _from, _amount));
19     }
20     return true;
21   }
22 
23   function callbackWithoutWithdrawl() {
24     callDataCalled = true;
25   }
26 
27   function callbackWithWithdrawl(uint _value, address _from, address _token) {
28     callDataCalled = true;
29     linkERC20 token = linkERC20(_token);
30     token.transferFrom(_from, this, _value);
31     tokensReceived = _value;
32   }
33 
34 }
