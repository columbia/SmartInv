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
11 contract TheToken is EIP20Interface {
12     uint256 constant private MAX_UINT256 = 2**256 - 1;
13     mapping (address => uint256) public balances;
14     mapping (address => mapping (address => uint256)) public allowed;
15     
16     string public name;                   //fancy name: eg Simon Bucks
17     uint8 public decimals;                //How many decimals to show.
18     string public symbol;                 //An identifier: eg SBX
19 
20     function TheToken(
21         uint256 _initialAmount,
22         string _tokenName,
23         uint8 _decimalUnits,
24         string _tokenSymbol
25     ) public {
26         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
27         totalSupply = _initialAmount;                        // Update total supply
28         name = _tokenName;                                   // Set the name for display purposes
29         decimals = _decimalUnits;                            // Amount of decimals for display purposes
30         symbol = _tokenSymbol;                               // Set the symbol for display purposes
31     }
32 
33     function transfer(address _to, uint256 _value) public returns (bool success) {
34         require(balances[msg.sender] >= _value);
35         balances[msg.sender] -= _value;
36         balances[_to] += _value;
37         Transfer(msg.sender, _to, _value);
38         return true;
39     }
40 
41     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
42         uint256 allowance = allowed[_from][msg.sender];
43         require(balances[_from] >= _value && allowance >= _value);
44         balances[_to] += _value;
45         balances[_from] -= _value;
46         if (allowance < MAX_UINT256) {
47             allowed[_from][msg.sender] -= _value;
48         }
49         Transfer(_from, _to, _value);
50         return true;
51     }
52 
53     function balanceOf(address _owner) public view returns (uint256 balance) {
54         return balances[_owner];
55     }
56 
57     function approve(address _spender, uint256 _value) public returns (bool success) {
58         allowed[msg.sender][_spender] = _value;
59         Approval(msg.sender, _spender, _value);
60         return true;
61     }
62 
63     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
64         return allowed[_owner][_spender];
65     }   
66 }