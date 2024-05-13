1 pragma solidity ^0.4.11;
2 
3 
4 import "./token/ERC677.sol";
5 import "./token/ERC677Receiver.sol";
6 
7 
8 contract ERC677Token is ERC677 {
9 
10   /**
11   * @dev transfer token to a contract address with additional data if the recipient is a contact.
12   * @param _to The address to transfer to.
13   * @param _value The amount to be transferred.
14   * @param _data The extra data to be passed to the receiving contract.
15   */
16   function transferAndCall(address _to, uint _value, bytes _data)
17     public
18     returns (bool success)
19   {
20     super.transfer(_to, _value);
21     Transfer(msg.sender, _to, _value, _data);
22     if (isContract(_to)) {
23       contractFallback(_to, _value, _data);
24     }
25     return true;
26   }
27 
28 
29   // PRIVATE
30 
31   function contractFallback(address _to, uint _value, bytes _data)
32     private
33   {
34     ERC677Receiver receiver = ERC677Receiver(_to);
35     receiver.onTokenTransfer(msg.sender, _value, _data);
36   }
37 
38   function isContract(address _addr)
39     private
40     returns (bool hasCode)
41   {
42     uint length;
43     assembly { length := extcodesize(_addr) }
44     return length > 0;
45   }
46 
47 }
