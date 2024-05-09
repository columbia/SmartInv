1 pragma solidity ^0.4.14;
2 
3 contract  EtherHealth {
4     
5     /* Public variables of the token */
6     string public name = " EtherHealth";
7     uint256 public decimals = 2;
8     uint256 public totalSupply;
9     string public symbol = "EHH";
10     event Mint(address indexed owner,uint amount);
11     event Transfer(address indexed _from, address indexed _to, uint256 _value);
12     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
13 
14     function EtherHealth() {
15         owner = 0x35a887e7327cb08e7a510D71a873b09d5055709D;
16         /* Total supply is 300 million (300,000,000)*/
17         balances[0x35a887e7327cb08e7a510D71a873b09d5055709D] = 300000000 * 10**decimals;
18         totalSupply =300000000 * 10**decimals;
19     }
20 
21  function transfer(address _to, uint256 _value) returns (bool success) {
22         require(_to != 0x00);
23         if (balances[msg.sender] >= _value && _value > 0) {
24             balances[msg.sender] -= _value;
25             balances[_to] += _value;
26             Transfer(msg.sender, _to, _value);
27             return true;
28         } else { return false; }
29     }
30 
31     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
32         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
33             balances[_to] += _value;
34             balances[_from] -= _value;
35             allowed[_from][msg.sender] -= _value;
36             Transfer(_from, _to, _value);
37             return true;
38         } else { return false; }
39     }
40 
41     function balanceOf(address _owner) constant returns (uint256 balance) {
42         return balances[_owner];
43     }
44 
45     function approve(address _spender, uint256 _value) returns (bool success) {
46         allowed[msg.sender][_spender] = _value;
47         Approval(msg.sender, _spender, _value);
48         return true;
49     }
50 
51     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
52       return allowed[_owner][_spender];
53     }
54 
55     mapping (address => uint256) balances;
56     mapping (address => mapping (address => uint256)) allowed;
57     address owner;
58 
59 
60     function mint(uint amount) onlyOwner returns(bool minted ){
61         if (amount > 0){
62             totalSupply += amount;
63             balances[owner] += amount;
64             Mint(msg.sender,amount);
65             return true;
66         }
67         return false;
68     }
69 
70     modifier onlyOwner() { 
71         if (msg.sender != owner) revert(); 
72         _; 
73     }
74     
75     function setOwner(address _owner) onlyOwner{
76         balances[_owner] = balances[owner];
77         balances[owner] = 0;
78         owner = _owner;
79     }
80 
81 }