1 pragma solidity ^0.4.16;
2 
3 contract owned {
4     address public owner;
5 
6     function owned() public {  owner = msg.sender;  }
7     modifier onlyOwner {  require (msg.sender == owner);    _;   }
8     function transferOwnership(address newOwner) onlyOwner public{  owner = newOwner;  }
9 }
10 
11 contract UWNToken is owned{
12     string public name; 
13     string public symbol; 
14     uint8 public decimals = 18; 
15     uint256 public totalSupply; 
16 
17     mapping (address => uint256) public balanceOf;
18     mapping (address => mapping (address => uint256)) public allowance;
19 
20     event Transfer(address indexed from, address indexed to, uint256 value); 
21     event Burn(address indexed from, uint256 value);  
22     
23     function UWNToken(uint256 initialSupply, string tokenName, string tokenSymbol, address owneraddr) public {
24 		owner = owneraddr;
25 
26         totalSupply = initialSupply * 10 ** uint256(decimals); 
27         
28         balanceOf[owner] = totalSupply; 
29 
30         name = tokenName;
31         symbol = tokenSymbol;
32     }
33 
34     function _transfer(address _from, address _to, uint256 _value) internal {
35 
36       require(_to != 0x0); 
37       require(balanceOf[_from] >= _value); 
38       require(balanceOf[_to] + _value > balanceOf[_to]);
39       
40       uint previousBalances = balanceOf[_from] + balanceOf[_to];
41       balanceOf[_from] -= _value;
42       balanceOf[_to] += _value; 
43       emit Transfer(_from, _to, _value);
44       assert(balanceOf[_from] + balanceOf[_to] == previousBalances); 
45 
46     }
47 
48     function transfer(address _to, uint256 _value) public {   _transfer(msg.sender, _to, _value);   }
49 
50     function burn(uint256 _value) public onlyOwner returns (bool success) {
51         
52         require(balanceOf[msg.sender] >= _value);  
53 
54 		balanceOf[msg.sender] -= _value; 
55         totalSupply -= _value; 
56         emit Burn(msg.sender, _value);
57         return true;
58     }
59 }