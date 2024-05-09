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
11 
12 contract CPCToken is EIP20Interface {
13     uint256 constant private MAX_UINT256 = 2**256 - 1;
14     mapping (address => uint256) public balances;
15     mapping (address => mapping (address => uint256)) public allowed;   
16     string public name;                   
17     uint8 public decimals;                
18     string public symbol;          
19     function CPCToken(
20         uint256 _initialAmount,
21         string _tokenName,
22         uint8 _decimalUnits,
23         string _tokenSymbol
24     ) public {
25         balances[msg.sender] = _initialAmount;               
26         totalSupply = _initialAmount;                        
27         name = _tokenName;                                   
28         decimals = _decimalUnits;                            
29         symbol = _tokenSymbol;                              
30     }
31 
32     function transfer(address _to, uint256 _value) public returns (bool success) {
33         require(balances[msg.sender] >= _value);
34         balances[msg.sender] -= _value;
35         balances[_to] += _value;
36         Transfer(msg.sender, _to, _value);
37         return true;
38     }
39 
40     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
41         uint256 allowance = allowed[_from][msg.sender];
42         require(balances[_from] >= _value && allowance >= _value);
43         balances[_to] += _value;
44         balances[_from] -= _value;
45         if (allowance < MAX_UINT256) {
46             allowed[_from][msg.sender] -= _value;
47         }
48         Transfer(_from, _to, _value);
49         return true;
50     }
51 
52     function balanceOf(address _owner) public view returns (uint256 balance) {
53         return balances[_owner];
54     }
55 
56     function approve(address _spender, uint256 _value) public returns (bool success) {
57         allowed[msg.sender][_spender] = _value;
58         Approval(msg.sender, _spender, _value);
59         return true;
60     }
61 
62     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
63         return allowed[_owner][_spender];
64     }   
65 }