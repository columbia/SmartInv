1 pragma solidity ^0.4.15;
2 
3 contract MyOwned {
4     address public owner;
5     function MyOwned() public { owner = msg.sender; }
6     modifier onlyOwner { require(msg.sender == owner ); _; }
7     function transferOwnership(address newOwner) onlyOwner public { owner = newOwner; }
8 }
9 
10 interface tokenRecipient { 
11     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; 
12 }
13 
14 contract MyToken is MyOwned {   
15     string public name;
16     string public symbol;
17     uint8 public decimals;
18     uint256 public totalSupply;
19     
20     mapping (address => uint256) public balanceOf;
21     mapping (address => bool) public frozenAccount;
22     event FrozenFunds(address target,bool frozen);
23     event Transfer(address indexed from,address indexed to,uint256 value);
24     
25     function MyToken(string tokenName,string tokenSymbol,uint8 decimalUnits,uint256 initialSupply){        
26         name = tokenName;
27         symbol = tokenSymbol;
28         decimals = decimalUnits;
29         totalSupply = initialSupply;
30         balanceOf[msg.sender] = initialSupply;
31 
32     }
33 
34     function transfer(address _to, uint256 _value){
35         require(!frozenAccount[msg.sender]);
36         require (balanceOf[msg.sender] >= _value);
37         require (balanceOf[_to] + _value >= balanceOf[_to]);
38         balanceOf[msg.sender] -= _value;
39         balanceOf[_to] += _value;
40         Transfer(msg.sender, _to, _value);
41     }
42     
43     function freezeAccount(address target,bool freeze) onlyOwner {
44         frozenAccount[target] = freeze;
45         FrozenFunds(target, freeze);
46     }
47 }