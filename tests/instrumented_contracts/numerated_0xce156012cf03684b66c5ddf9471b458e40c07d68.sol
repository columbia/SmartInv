1 contract EIP20Interface {    
2     uint256 public totalSupply;
3     function balanceOf(address _owner) public view returns (uint256 balance);
4     function transfer(address _to, uint256 _value) public returns (bool success);
5     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
6     function approve(address _spender, uint256 _value) public returns (bool success);
7     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
8     event Transfer(address indexed _from, address indexed _to, uint256 _value); 
9     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
10 }
11 contract CPCToken is EIP20Interface {
12     uint256 constant private MAX_UINT256 = 2**256 - 1;
13     mapping (address => uint256) public balances;
14     mapping (address => mapping (address => uint256)) public allowed;   
15     string public name;                   
16     uint8 public decimals;                
17     string public symbol;          
18     function CPCToken(
19         uint256 _initialAmount,
20         string _tokenName,
21         uint8 _decimalUnits,
22         string _tokenSymbol
23     ) public {
24         balances[msg.sender] = _initialAmount;               
25         totalSupply = _initialAmount;                        
26         name = _tokenName;                                   
27         decimals = _decimalUnits;                            
28         symbol = _tokenSymbol;                              
29 }
30 
31 function rename(string newTokenName,string newSymbol) public returns(bool success)
32 {
33   name = newTokenName;
34   symbol = newSymbol;  
35   return true;
36 }
37     function transfer(address _to, uint256 _value) public returns (bool success) {
38         require(balances[msg.sender] >= _value);
39         balances[msg.sender] -= _value;
40         balances[_to] += _value;
41         Transfer(msg.sender, _to, _value);
42         return true;
43     }
44 
45     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
46         uint256 allowance = allowed[_from][msg.sender];
47         require(balances[_from] >= _value && allowance >= _value);
48         balances[_to] += _value;
49         balances[_from] -= _value;
50         if (allowance < MAX_UINT256) {
51             allowed[_from][msg.sender] -= _value;
52         }
53         Transfer(_from, _to, _value);
54         return true;
55     }
56 
57     function balanceOf(address _owner) public view returns (uint256 balance) {
58         return balances[_owner];
59     }
60 
61     function approve(address _spender, uint256 _value) public returns (bool success) {
62         allowed[msg.sender][_spender] = _value;
63         Approval(msg.sender, _spender, _value);
64         return true;
65     }
66 
67     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
68         return allowed[_owner][_spender];
69     }   
70 }