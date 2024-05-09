1 contract USDB{
2  
3     string public name="USDB";
4     string public symbol="USDB";
5     
6     uint256 public totalSupply; 
7     uint256 public price = 1;
8     uint256 public decimals = 18; 
9 
10     address Owner;
11     
12     mapping (address => uint256) balances; 
13     event Transfer(address indexed from, address indexed to, uint256 value);
14     event Burn(address indexed from, uint256 value);
15     constructor() public { 
16         Owner = msg.sender;
17         name="USDB";
18         symbol="USDB";
19         totalSupply = 1000000000*10**18;
20         balances[Owner] = totalSupply;
21     }
22 
23     modifier onlyOwner(){
24         require(msg.sender == Owner);
25         _;
26     }
27 
28     modifier validAddress(address _to){
29         require(_to != address(0x00));
30         _;
31     }
32     
33     function setName(string _name) onlyOwner public returns (string){
34          name = _name;
35          return name;
36     }
37     
38      function setPrice(uint256 _price) onlyOwner public returns (uint256){
39          price = _price;
40          return price;
41      }
42     
43      function setDecimals(uint256 _decimals) onlyOwner public returns (uint256){
44          decimals = _decimals;
45          return decimals;
46      }
47     
48 
49      function getOwner() view public returns(address){
50         return Owner;
51      }
52     
53     function balanceOf(address _owner) view public returns(uint256){
54         return balances[_owner];
55     }
56    
57     function create(uint256 _value) public onlyOwner returns (bool success) {
58         totalSupply += _value;
59         balances[Owner] += _value;
60         return true;
61     }
62     function burn(uint256 _value) onlyOwner public returns (bool success) {
63          require(balances[msg.sender] >= _value); 
64          balances[msg.sender] -= _value; 
65          totalSupply -= _value; 
66          emit Burn(msg.sender, _value);
67          return true;
68     }
69     /*
70      * @dev Transfers sender's tokens to a given address. Returns success.
71      * @param _from Address of Owner.
72      * @param _to Address of token receiver.
73      * @param _value Number of tokens to transfer.
74      */
75     
76     function _transfer(address _from, address _to, uint _value) internal {
77         require(_to != 0x0);
78         require(balances[_from] >= _value);
79         require(balances[_to] + _value >= balances[_to]);
80         
81         uint previousBalances = balances[_from] + balances[_to];
82         
83         balances[_from] -= _value;
84         balances[_to] += _value;
85         
86         assert(balances[_from] + balances[_to] == previousBalances);
87         emit Transfer(_from, _to, _value);
88     }
89 
90     function transfer(address _to, uint256 _value) public payable onlyOwner returns (bool success) {
91         _transfer(msg.sender, _to, _value);
92         return true;
93     }
94     
95 }