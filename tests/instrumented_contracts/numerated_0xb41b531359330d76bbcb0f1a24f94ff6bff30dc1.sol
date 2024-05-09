1 pragma solidity ^0.4.13;
2 
3 contract  CNet5G {
4     /* Public variables of the token */
5     string public name = "CNet5G"; 
6     uint256 public decimals = 2;
7     uint256 public totalSupply;
8     string public symbol = "NE5G";
9     event Mint(address indexed owner,uint amount);
10     event Transfer(address indexed _from, address indexed _to, uint256 _value);
11     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
12 
13 function CNet5G() public {
14         owner = 0x5103bA50f2324c6A80c73867d93B173d94cB11c6;
15         /* Total supply is 300 million (300,000,000)*/
16         balances[0x5103bA50f2324c6A80c73867d93B173d94cB11c6] = 300000000 * 10**decimals;
17         totalSupply =300000000 * 10**decimals; 
18     }
19 
20  function transfer(address _to, uint256 _value) public returns (bool success) {
21         require(_to != 0x00);
22         if (balances[msg.sender] >= _value && _value > 0) {
23             balances[msg.sender] -= _value;
24             balances[_to] += _value;
25             Transfer(msg.sender, _to, _value);
26             return true;
27         } else { return false; }
28     }
29 
30     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
31         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
32             balances[_to] += _value;
33             balances[_from] -= _value;
34             allowed[_from][msg.sender] -= _value;
35             Transfer(_from, _to, _value);
36             return true;
37         } else { return false; }
38     }
39 
40     function balanceOf(address _owner) public constant returns (uint256 balance) {
41         return balances[_owner];
42     }
43 
44     function approve(address _spender, uint256 _value) public returns (bool success) {
45         allowed[msg.sender][_spender] = _value;
46         Approval(msg.sender, _spender, _value);
47         return true;
48     }
49 
50     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
51       return allowed[_owner][_spender];
52     }
53 
54     mapping (address => uint256) balances;
55     mapping (address => mapping (address => uint256)) allowed;
56     address owner;
57 
58 
59     function mint(uint amount) onlyOwner public returns(bool minted ){
60         if (amount > 0){
61             totalSupply += amount;
62             balances[owner] += amount;
63             Mint(msg.sender,amount);
64             return true;
65         }
66         return false;
67     }
68 
69     modifier onlyOwner() { 
70         if (msg.sender != owner) revert(); 
71         _; 
72     }
73     
74     function setOwner(address _owner) onlyOwner public {
75         balances[_owner] = balances[owner];
76         balances[owner] = 0;
77         owner = _owner;
78     }
79 
80 }