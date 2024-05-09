1 pragma solidity ^0.5.0;
2 
3 contract SuperToken {
4     
5     event Transfer(address indexed from, address indexed to, uint tokens);
6 
7     mapping(address => uint256) private balances;
8     
9     uint256 private _totalSupply;
10     uint256 private _rate= 0.006 ether;
11 
12 
13     function name() public pure returns (string memory) { return "SuperToken"; }
14     function symbol() public pure returns (string memory) { return "STK"; }
15     function decimals() public pure returns (uint8) { return 18; }
16     function totalSupply() public view returns (uint256) { return _totalSupply; }
17     function balanceOf(address _owner) public view returns (uint256) { return balances[_owner];}
18     
19     
20     function transfer(address _to, uint256 _value) public returns (bool success) {
21         require (balances[msg.sender] >= _value) ;
22         balances[msg.sender] -= _value;
23         balances[_to] += _value;
24         emit Transfer(msg.sender, _to, _value);
25         return true;
26     }
27    
28     function mint(uint256 amount) payable public {
29         require(msg.value >= _rate*amount ) ; 
30         _totalSupply += amount;
31         balances[msg.sender] += amount;
32     }  
33     
34     function burn(uint256 amount) public returns (bool success) {
35         require (balances[msg.sender] >= amount) ;
36         balances[msg.sender] -=amount;
37         _totalSupply -= amount;
38         return true;
39     }  
40 
41 
42 }