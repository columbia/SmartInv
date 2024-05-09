1 //This glorious coin is named after an ethical woman named Ingrid Zurlo.
2 //Hopefully this plummits in value and becomes a useful tool for people looking
3 //to learn a little coding. The individual this is named after also inspired a 
4 //a different coin called twiceAweekCoin, but that's a more legit effort to make
5 //something. 
6 
7 //  Children should always be at the center of their parents' decisions!
8 
9 pragma solidity ^0.4.23;
10 
11 contract SystemTesterCode {
12 
13     uint256 public totalSupply;
14     
15     function balanceOf(address _owner) public view returns (uint256 balance);
16 
17     function transfer(address _to, uint256 _value) public returns (bool success);
18 
19     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
20 
21     function approve(address _spender, uint256 _value) public returns (bool success);
22 
23     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
24 
25     event Transfer(address indexed _from, address indexed _to, uint256 _value);
26 
27     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
28 }
29 
30 contract IngridIsAHorribleHumanCoin is SystemTesterCode {
31 
32     uint256 constant private MAX_UINT256 = 2**256 - 1;
33     mapping (address => uint256) public balances;
34     mapping (address => mapping (address => uint256)) public allowed;
35     
36     string public name;                   
37     uint8 public decimals;              
38     string public symbol;                 
39 
40     function IngridIsAHorribleHumanCoin(
41         uint256 _initialAmount,
42         string _tokenName,
43         uint8 _decimalUnits,
44         string _tokenSymbol
45     ) public {
46         balances[msg.sender] = _initialAmount;
47         totalSupply = _initialAmount;
48         name = _tokenName;
49         decimals = _decimalUnits;
50         symbol = _tokenSymbol;
51     }
52 
53     function transfer(address _to, uint256 _value) public returns (bool success) {
54         require(balances[msg.sender] >= _value);
55         balances[msg.sender] -= _value;
56         balances[_to] += _value;
57         emit Transfer(msg.sender, _to, _value); 
58         return true;
59     }
60 
61     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
62         uint256 allowance = allowed[_from][msg.sender];
63         require(balances[_from] >= _value && allowance >= _value);
64         balances[_to] += _value;
65         balances[_from] -= _value;
66         if (allowance < MAX_UINT256) {
67             allowed[_from][msg.sender] -= _value;
68         }
69         emit Transfer(_from, _to, _value);
70         return true;
71     }
72 
73     function balanceOf(address _owner) public view returns (uint256 balance) {
74         return balances[_owner];
75     }
76 
77     function approve(address _spender, uint256 _value) public returns (bool success) {
78         allowed[msg.sender][_spender] = _value;
79         emit Approval(msg.sender, _spender, _value);
80         return true;
81     }
82 
83     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
84         return allowed[_owner][_spender];
85     }
86 }