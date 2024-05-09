1 pragma solidity >=0.4.22 <0.6.0;
2 
3 interface tokenRecipient { 
4     function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external; 
5 }
6 
7 contract QHC {
8     
9     string public name;
10     string public symbol;
11     uint8 public decimals = 18;
12     uint256 public totalSupply;
13 
14     mapping (address => uint256) public balanceOf;
15     mapping (address => mapping (address => uint256)) public allowance;
16 
17     event Transfer(address indexed from, address indexed to, uint256 value);
18     
19     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
20 
21     event Burn(address indexed from, uint256 value);
22  
23     constructor(
24         uint256 initialSupply,
25         string memory tokenName,
26         string memory tokenSymbol
27     ) public {
28         totalSupply = initialSupply * 10 ** uint256(decimals);  
29         balanceOf[msg.sender] = totalSupply;                
30         name = tokenName;                                   
31         symbol = tokenSymbol;                               
32     }
33     
34     function _transfer(address _from, address _to, uint _value) internal {
35         
36         require(_to != address(0x0));
37         require(balanceOf[_from] >= _value);
38         require(balanceOf[_to] + _value >= balanceOf[_to]);
39         uint previousBalances = balanceOf[_from] + balanceOf[_to];
40         balanceOf[_from] -= _value;
41         balanceOf[_to] += _value;
42         emit Transfer(_from, _to, _value);
43         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
44     }
45 
46     /**
47      * @param _to The address of the recipient
48      * @param _value the amount to send
49      */
50     function transfer(address _to, uint256 _value) public returns (bool success) {
51         _transfer(msg.sender, _to, _value);
52         return true;
53     }
54 
55     /**
56      * @param _from The address of the sender
57      * @param _to The address of the recipient
58      * @param _value the amount to send
59      */
60     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
61         require(_value <= allowance[_from][msg.sender]);     
62         allowance[_from][msg.sender] -= _value;
63         _transfer(_from, _to, _value);
64         return true;
65     }
66 
67     /**
68      * @param _spender The address authorized to spend
69      * @param _value the max amount they can spend
70      */
71     function approve(address _spender, uint256 _value) public
72         returns (bool success) {
73         allowance[msg.sender][_spender] = _value;
74         emit Approval(msg.sender, _spender, _value);
75         return true;
76     }
77 
78     /**
79      * @param _spender The address authorized to spend
80      * @param _value the max amount they can spend
81      * @param _extraData some extra information to send to the approved contract
82      */
83     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData)
84         public
85         returns (bool success) {
86         tokenRecipient spender = tokenRecipient(_spender);
87         if (approve(_spender, _value)) {
88             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
89             return true;
90         }
91     }
92 
93     /**
94      * @param _value the amount of money to burn
95      */
96     function burn(uint256 _value) public returns (bool success) {
97         require(balanceOf[msg.sender] >= _value);   
98         balanceOf[msg.sender] -= _value;           
99         totalSupply -= _value;                      
100         emit Burn(msg.sender, _value);
101         return true;
102     }
103 
104     /**
105      * @param _from the address of the sender
106      * @param _value the amount of money to burn
107      */
108     function burnFrom(address _from, uint256 _value) public returns (bool success) {
109         require(balanceOf[_from] >= _value);                
110         require(_value <= allowance[_from][msg.sender]);    
111         balanceOf[_from] -= _value;                         
112         allowance[_from][msg.sender] -= _value;            
113         totalSupply -= _value;                              
114         emit Burn(_from, _value);
115         return true;
116     }
117 }