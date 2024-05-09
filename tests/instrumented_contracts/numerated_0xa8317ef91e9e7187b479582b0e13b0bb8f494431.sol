1 pragma solidity ^0.4.13;
2 
3 contract DavidCoin {
4     
5     // totalSupply = Maximum is 1000 Coins with 18 decimals;
6     // This Coin is made for Mr. David Bayer.
7     // Made from www.appstoreweb.net.
8 
9     uint256 public totalSupply = 1000000000000000000000;
10     uint256 public circulatingSupply = 0;  	
11     uint8   public decimals = 18;
12     bool    initialized = false;    
13   
14     string  public standard = 'ERC20 Token';
15     string  public name = 'DavidCoin';
16     string  public symbol = 'David';                          
17     address public owner = msg.sender; 
18 
19     mapping (address => uint256) balances;
20     mapping (address => mapping (address => uint256)) allowed;	
21 	
22     event Transfer(address indexed _from, address indexed _to, uint256 _value);
23     event Approval(address indexed _owner, address indexed _spender, uint256 _value);    
24     
25     function transfer(address _to, uint256 _value) returns (bool success) {
26         if (balances[msg.sender] >= _value && _value > 0) {
27             balances[msg.sender] -= _value;
28             balances[_to] += _value;
29             Transfer(msg.sender, _to, _value);
30             return true;
31         } else { return false; }
32     }
33 
34     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
35         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
36             balances[_to] += _value;
37             balances[_from] -= _value;
38             allowed[_from][msg.sender] -= _value;
39             Transfer(_from, _to, _value);
40             return true;
41         } else { return false; }
42     }
43 
44     function balanceOf(address _owner) constant returns (uint256 balance) {
45         return balances[_owner];
46     }
47 
48     function approve(address _spender, uint256 _value) returns (bool success) {
49         allowed[msg.sender][_spender] = _value;
50         Approval(msg.sender, _spender, _value);
51         return true;
52     }
53 
54     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
55       return allowed[_owner][_spender];
56     }
57 	
58     function transferOwnership(address newOwner) {
59         if (msg.sender == owner){
60             owner = newOwner;
61         }
62     }	
63     
64     function initializeCoins() {
65         if (msg.sender == owner){
66             if (!initialized){
67                 balances[msg.sender] = totalSupply;
68 		circulatingSupply = totalSupply;
69                 initialized = true;
70             }
71         }
72     }    
73 	
74 }