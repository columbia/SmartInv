1 pragma solidity ^0.4.24;
2 contract ERCDDAToken {
3   address public owner;
4   string public name;
5   string public symbol;
6   uint8 public decimals = 0;
7   uint256 public totalSupply;
8   
9   event Transfer(address indexed from, address indexed to, uint256 value);
10   event FrozenFunds(address target, bool frozen);
11   event Burn(address indexed from, uint256 value);
12   mapping (address => uint256) public balanceOf;
13   mapping (address => bool) public frozenAccount;
14 
15     function owned() public {
16         owner = msg.sender;
17     }
18 
19     modifier onlyOwner {
20         require(msg.sender == owner);
21         _;
22     }
23     
24   constructor(
25         uint256 initialSupply,
26         string tokenName,
27         string tokenSymbol
28     ) public {
29         owner = msg.sender;
30         totalSupply = initialSupply * 10 ** uint256(decimals);
31         balanceOf[msg.sender] = totalSupply;
32         name = tokenName;
33         symbol = tokenSymbol;
34     }
35 
36     function _transfer(address _from, address _to, uint _value) internal {
37         require (_to != 0x0);
38         require (balanceOf[_from] >= _value);
39         require (balanceOf[_to] + _value >= balanceOf[_to]); 
40         require(!frozenAccount[_from]);
41         require(!frozenAccount[_to]);
42         balanceOf[_from] -= _value;
43         balanceOf[_to] += _value;
44         emit Transfer(_from, _to, _value);
45     }
46 
47     function transfer(address _to, uint256 _value) public returns (bool success) {
48         _transfer(msg.sender, _to, _value);
49         return true;
50     }
51 
52     function freezeAccount(address target, bool freeze) onlyOwner public {
53         frozenAccount[target] = freeze;
54         emit FrozenFunds(target, freeze);
55     }
56 
57     function burn(uint256 _value) onlyOwner public returns (bool success) {
58         require(balanceOf[msg.sender] >= _value);
59         balanceOf[msg.sender] -= _value;
60         totalSupply -= _value;
61         emit Burn(msg.sender, _value);
62         return true;
63     }
64 
65 	function mintToken(address target, uint256 mintedAmount) onlyOwner public{
66 		balanceOf[target] += mintedAmount;
67 		totalSupply += mintedAmount;
68 	}
69 }