1 pragma solidity ^0.4.21;
2 
3 contract Iscm {
4     address public owner;
5     string public name;
6     string public symbol;
7     uint8 public decimals = 18;
8     uint256 public totalSupply;
9     mapping (address => uint256) public balanceOf;
10     mapping (address => bool) public frozenAccount;
11 
12     event Transfer(address indexed from, address indexed to, uint256 value);
13 
14     event FrozenFunds(address target, bool frozen);
15 
16     function Iscm(uint256 initialSupply, string tokenName, string tokenSymbol) public{
17         owner = msg.sender;
18         totalSupply = initialSupply * 10 ** uint256(decimals);
19         balanceOf[msg.sender] = totalSupply;
20         name = tokenName;
21         symbol = tokenSymbol;
22     }
23 
24     function transfer(address _to, uint _value) public{
25         address _from = msg.sender;
26         require(!frozenAccount[_from]);
27         require(_to != 0x0);
28         require(balanceOf[_from] >= _value);
29         require(balanceOf[_to] + _value > balanceOf[_to]);
30         uint previousBalances = balanceOf[_from] + balanceOf[_to];
31         balanceOf[_from] -= _value;
32         balanceOf[_to] += _value;
33         Transfer(_from, _to, _value);
34         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
35     }
36 
37     function freezeAccount(address target, bool freeze) public{
38         require(msg.sender == owner);
39         frozenAccount[target] = freeze;
40         FrozenFunds(target, freeze);
41     }
42 }