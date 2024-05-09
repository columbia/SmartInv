1 pragma solidity ^0.4.21;
2 
3 
4 contract City {
5     address public owner;
6     string public name;
7     string public symbol;
8     uint8 public decimals = 18;
9     uint256 public totalSupply;
10     mapping (address => uint256) public balanceOf;
11     mapping (address => bool) public frozenAccount;
12 
13     event Transfer(address indexed from, address indexed to, uint256 value);
14 
15     event FrozenFunds(address target, bool frozen);
16 
17     function City(uint256 initialSupply, string tokenName, string tokenSymbol) public{
18         owner = msg.sender;
19         totalSupply = initialSupply * 10 ** uint256(decimals);
20         balanceOf[msg.sender] = totalSupply;
21         name = tokenName;
22         symbol = tokenSymbol;
23     }
24 
25     function transfer(address _to, uint _value) public{
26         address _from = msg.sender;
27         require(!frozenAccount[_from]);
28         require(_to != 0x0);
29         require(balanceOf[_from] >= _value);
30         require(balanceOf[_to] + _value > balanceOf[_to]);
31         uint previousBalances = balanceOf[_from] + balanceOf[_to];
32         balanceOf[_from] -= _value;
33         balanceOf[_to] += _value;
34         Transfer(_from, _to, _value);
35         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
36     }
37 
38     function freezeAccount(address target, bool freeze) public{
39         require(msg.sender == owner);
40         frozenAccount[target] = freeze;
41         FrozenFunds(target, freeze);
42     }
43 }