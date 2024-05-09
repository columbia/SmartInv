1 pragma solidity ^0.4.11;
2 
3 
4 import "./token/ERC677.sol";
5 import "./token/ERC677Receiver.sol";
6 
7 
8 contract ERC677Token is ERC677 {
9 
10   function transferAndCall(address _to, uint _value, bytes _data)
11     public
12     returns (bool success)
13   {
14     super.transfer(_to, _value);
15     Transfer(msg.sender, _to, _value, _data);
16     if (isContract(_to)) {
17       contractFallback(_to, _value, _data);
18     }
19     return true;
20   }
21 
22 
23   // PRIVATE
24 
25   function contractFallback(address _to, uint _value, bytes _data)
26     private
27   {
28     ERC677Receiver receiver = ERC677Receiver(_to);
29     receiver.onTokenTransfer(msg.sender, _value, _data);
30   }
31 
32 
33 }
34 
35 contract TokenTransfer{
36     function transfer(address _to, uint256 _value) public returns (bool) {
37         require(superTransfer(_to, _value));
38         callAfterTransfer(msg.sender, _to, _value);
39         return true;
40     }
41  
42  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
43         require(super.transferFrom(_from, _to, _value));
44         callAfterTransfer(_from, _to, _value);
45         return true;
46     }
47  
48  
49  function contractFallback(address _from, address _to, uint256 _value, bytes _data) private returns (bool) {
50         return _to.call(abi.encodeWithSelector(ON_TOKEN_TRANSFER, _from, _value, _data));
51     }
52 }