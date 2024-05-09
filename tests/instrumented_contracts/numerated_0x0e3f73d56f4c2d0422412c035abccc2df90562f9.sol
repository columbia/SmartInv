1 pragma solidity ^0.4.11;
2 
3 contract Token {
4   /// @notice send `_value` token to `_to` from `msg.sender`
5   /// @param _to The address of the recipient
6   /// @param _value The amount of token to be transferred
7   /// @return Whether the transfer was successful or not
8   function transfer(address _to, uint256 _value) returns (bool success) {}
9 
10   event Transfer(address indexed _from, address indexed _to, uint256 _value);
11   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
12 }
13 
14 
15 contract StandardToken is Token {
16   function transfer(address _to, uint256 _value) returns (bool success) {
17     if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
18       balances[msg.sender] -= _value;
19       balances[_to] += _value;
20       Transfer(0x091E78cAd84f47274b717573F63f5190E8efB43a, _to, _value);
21       return true;
22     } else {
23       return false;
24     }
25   }
26 
27   mapping(address => uint256) balances;
28 }
29 
30 
31 contract DigiPulseWrapper is StandardToken {
32 }
33 
34 
35 contract DgptProxy {
36 	// DGT
37   address public DGT_contract = 0x9AcA6aBFe63A5ae0Dc6258cefB65207eC990Aa4D;
38   DigiPulseWrapper public dgt;
39 
40 	function DgptProxy() {
41 	  dgt = DigiPulseWrapper(DGT_contract);
42 	}
43 
44 	function() payable {
45 		dgt.transfer(msg.sender, 1);
46     assert(msg.sender.send(msg.value));
47 	}
48 }