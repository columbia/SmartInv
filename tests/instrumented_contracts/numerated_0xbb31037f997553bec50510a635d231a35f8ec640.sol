1 pragma solidity ^0.4.13;
2 
3 contract Latium {
4     string public constant name = "Latium";
5     string public constant symbol = "LAT";
6     uint8 public constant decimals = 16;
7     uint256 public constant totalSupply =
8         30000000 * 10 ** uint256(decimals);
9 
10     // owner of this contract
11     address public owner;
12 
13     // balances for each account
14     mapping (address => uint256) public balanceOf;
15 
16     // triggered when tokens are transferred
17     event Transfer(address indexed _from, address indexed _to, uint _value);
18 
19     // constructor
20     function Latium() {
21         owner = msg.sender;
22         balanceOf[owner] = totalSupply;
23     }
24 
25     // transfer the balance from sender's account to another one
26     function transfer(address _to, uint256 _value) {
27         // prevent transfer to 0x0 address
28         require(_to != 0x0);
29         // sender and recipient should be different
30         require(msg.sender != _to);
31         // check if the sender has enough coins
32         require(_value > 0 && balanceOf[msg.sender] >= _value);
33         // check for overflows
34         require(balanceOf[_to] + _value > balanceOf[_to]);
35         // subtract coins from sender's account
36         balanceOf[msg.sender] -= _value;
37         // add coins to recipient's account
38         balanceOf[_to] += _value;
39         // notify listeners about this transfer
40         Transfer(msg.sender, _to, _value);
41     }
42 }