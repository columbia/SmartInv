1 pragma solidity >=0.4.22 <0.6.0;
2 contract Token{
3     uint256 public totalSupply;
4     function balanceOf(address _owner) public view returns (uint256 balance);
5     function transfer(address _to, uint256 _value) public returns (bool success);
6     function transferFrom(address _from,address _to,uint256 _value)public returns(bool success);
7     function approve(address _spender, uint256 _value) public returns (bool success);
8     function allowance(address _owner, address _spender) public view returns  (uint256 remaining);
9     event Transfer(address indexed _from, address indexed _to, uint256 _value);
10     event Approval(address indexed _owner, address indexed _spender, uint256  _value);
11     event Burn(address indexed from, uint256 value);
12 }
13 
14 contract FSCToken is Token{
15     string public chinaName;
16     string public name;
17     string public symbol;
18     uint8 public decimals;
19     address public owner;
20     mapping(address=>uint256) balances;
21     mapping (address => mapping (address => uint256)) allowed;
22     
23     constructor(uint256 _initialAmount, string memory _tokenName,string memory _chinaName,uint8 _decimalUnits, string memory _tokenSymbol) public{
24         totalSupply = _initialAmount * 10 ** uint256(_decimalUnits);
25         balances[msg.sender] = totalSupply;
26         name=_tokenName;
27         decimals=_decimalUnits;
28         symbol=_tokenSymbol;
29         chinaName=_chinaName;
30         owner=msg.sender;
31     }
32     
33     function _transfer(address _from, address _to, uint _value) internal {
34         require(_to != address(0x0));
35         require(balances[_from] >= _value);
36         require(balances[_to] + _value >= balances[_to]);
37         uint previousBalances = balances[_from] + balances[_to];
38         balances[_from] -= _value;
39         balances[_to] += _value;
40         emit Transfer(_from, _to, _value);
41         assert(balances[_from] + balances[_to] == previousBalances);
42     }    
43     
44     function transfer(address _to, uint256 _value) public returns (bool success) {
45         _transfer(msg.sender, _to, _value);
46         return true;
47     }
48     
49     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
50         require(_value <= allowed[_from][msg.sender]);     
51         allowed[_from][msg.sender] -= _value;
52         _transfer(_from, _to, _value);
53         return true;
54     }
55     
56     function balanceOf(address _owner) public view returns (uint256 balance) {
57         return balances[_owner];
58     }
59     
60     function approve(address _spender, uint256 _value) public returns (bool success)   
61     { 
62         allowed[msg.sender][_spender] = _value;
63         emit Approval(msg.sender, _spender, _value);
64         return true;
65     }
66 
67     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
68         return allowed[_owner][_spender];
69     }  
70     
71     function burn(uint256 _value) public returns (bool success) {
72         require(msg.sender==owner);
73         require(balances[msg.sender] >= _value);  
74         balances[msg.sender] -= _value;            
75         totalSupply -= _value;                      
76         emit Burn(msg.sender, _value);
77         return true;
78     }    
79     
80     function burnFrom(address _from, uint256 _value) public returns (bool success) {
81         require(msg.sender==owner);
82         require(balances[_from] >= _value);                
83         require(_value <= allowed[_from][msg.sender]);    
84         balances[_from] -= _value;                        
85         allowed[_from][msg.sender] -= _value;             
86         totalSupply -= _value;                              
87         emit Burn(_from, _value);
88         return true;
89     }
90     
91 }