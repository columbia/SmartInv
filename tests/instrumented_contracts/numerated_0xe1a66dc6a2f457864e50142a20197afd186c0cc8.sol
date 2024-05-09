1 pragma solidity ^0.4.19;
2 
3 contract BaseToken{    
4     string public name;      
5     string public symbol;     
6     uint8 public decimals;   
7     uint256 public totalSupply;     
8 
9     mapping (address => uint256) balances;
10     mapping (address => mapping (address => uint256)) public allowance;   
11     
12     event Transfer(address indexed from, address indexed to, uint256 value);
13     event Approval(address indexed owner, address indexed spender, uint256 value);
14     event FrozenFunds(address target, bool frozen);  
15 
16     address public owner;
17     modifier onlyOwner {        
18         require(msg.sender == owner);       
19         _;
20     } 
21     mapping (address => bool) public frozenAccount;
22     function freezeAccount(address target, bool freeze) public onlyOwner {
23         frozenAccount[target] = freeze;        
24         FrozenFunds(target, freeze);
25     }
26 
27     function balanceOf(address _owner) public view returns (uint256 balance) {        
28         return balances[_owner];
29     }   
30 
31     function _transfer(address _from, address _to, uint _value) internal {        
32         require(!frozenAccount[_from]); 
33         require(_to != 0x0);
34         require(balances[_from] >= _value);
35         require(balances[_to] + _value > balances[_to]);
36         balances[_from] -= _value;
37         balances[_to] += _value;
38         Transfer(_from, _to, _value);
39     }
40 
41     function transfer(address _to, uint256 _value) public returns (bool success) {
42         _transfer(msg.sender, _to, _value);
43         return true;
44     }
45 
46     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
47         require(_value <= allowance[_from][msg.sender]);        
48         _transfer(_from, _to, _value);
49         allowance[_from][msg.sender] -= _value;
50         return true;
51     }
52 
53     function approve(address _spender, uint256 _value) public returns (bool success) {
54         allowance[msg.sender][_spender] = _value;
55         Approval(msg.sender, _spender, _value);
56         return true;
57     }
58 }
59 
60 contract CustomToken is BaseToken {
61     function CustomToken() public {
62         totalSupply = 2.6 * 100000000 * 1000000;           
63         owner = 0x690Ae62C7b56F08d0d712c6e4Ef1103a5A0B38F9;      
64         balances[owner] = totalSupply; 
65         name = 'Garlic Chain'; 
66         symbol = 'GLC';                    
67         decimals = 6; 
68         Transfer(address(0), owner, totalSupply);
69     }    
70 }