1 pragma solidity ^0.5.9;
2  
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */ 
7 library SafeMath{
8     function mul(uint a, uint b) internal pure returns (uint){
9         uint c = a * b;
10         assert(a == 0 || c / a == b);
11         return c;
12     }
13  
14     function div(uint a, uint b) internal pure returns (uint){
15         uint c = a / b;
16         return c;
17     }
18  
19     function sub(uint a, uint b) internal pure returns (uint){
20         assert(b <= a); 
21         return a - b; 
22     } 
23   
24     function add(uint a, uint b) internal pure returns (uint){ 
25         uint c = a + b; assert(c >= a);
26         return c;
27     }
28 }
29 
30 /**
31  * @title BIP Token token
32  * @dev ERC20 Token implementation, with its own specific
33  */
34 contract BIPToken{
35     using SafeMath for uint;
36     
37     string public constant name = "Blockchain Invest Platform Token";
38     string public constant symbol = "BIP";
39     uint32 public constant decimals = 18;
40 
41     address public constant addressICO = 0x6712397d604410b0F99A205Aa8f7ac1B1a358F91;
42     address public constant addressInvestors = 0x83DBcaDD8e9c7535DD0Dc42356B8e0AcDccb8c2b;
43     address public constant addressMarketing = 0x01D98aa48D98bae8F1E30Ebf2A31b532018C3C61;
44     address public constant addressPreICO = 0xE556E2Dd0fE094032FD7242c7880F140c89f17B8;
45     address public constant addressTeam = 0xa3C9E790979D226435Da43022e41AF1CA7f8080B;
46     address public constant addressBounty = 0x9daf97360086e1454ea8379F61ae42ECe0935740;
47     
48     uint public totalSupply = 200000000 * 1 ether;
49     mapping(address => uint) balances;
50     mapping (address => mapping (address => uint)) internal allowed;
51     
52     event Transfer(address indexed from, address indexed to, uint value);
53     event Approval(address indexed owner, address indexed spender, uint value);
54 
55     /** 
56      * @dev Initial token transfers.
57      */
58     constructor() public{
59         balances[msg.sender] = totalSupply;
60         emit Transfer(address(0), msg.sender, totalSupply);
61 
62         _transfer(addressICO,       124000000 * 1 ether);
63         _transfer(addressInvestors,  32000000 * 1 ether);
64         _transfer(addressMarketing,  16000000 * 1 ether);
65         _transfer(addressPreICO,     14000000 * 1 ether);
66         _transfer(addressTeam,        8000000 * 1 ether);
67         _transfer(addressBounty,      6000000 * 1 ether);
68     }
69     
70     /** 
71      * @dev Gets the balance of the specified address.
72      * @param _owner The address to query the the balance of.
73      * @return An uint256 representing the amount owned by the passed address.
74      */
75     function balanceOf(address _owner) public view returns (uint){
76         return balances[_owner];
77     }
78  
79     /**
80      * @dev Transfer token for a specified address
81      * @param _to The address to transfer to.
82      * @param _value The amount to be transferred.
83      */ 
84     function _transfer(address _to, uint _value) private returns (bool){
85         require(msg.sender != address(0));
86         require(_to != address(0));
87         require(_value > 0 && _value <= balances[msg.sender]);
88         balances[msg.sender] = balances[msg.sender].sub(_value);
89         balances[_to] = balances[_to].add(_value);
90         emit Transfer(msg.sender, _to, _value);
91         return true; 
92     }
93 
94     /**
95      * @dev Transfer token for a specified address
96      * @param _to The address to transfer to.
97      * @param _value The amount to be transferred.
98      */ 
99     function transfer(address _to, uint _value) public returns (bool){
100         return _transfer(_to, _value);
101     } 
102     
103     /**
104      * @dev Transfer several token for a specified addresses
105      * @param _to The array of addresses to transfer to.
106      * @param _value The array of amounts to be transferred.
107      */ 
108     function massTransfer(address[] memory _to, uint[] memory _value) public returns (bool){
109         require(_to.length == _value.length);
110 
111         uint len = _to.length;
112         for(uint i = 0; i < len; i++){
113             if(!_transfer(_to[i], _value[i])){
114                 return false;
115             }
116         }
117         return true;
118     } 
119     
120     /**
121      * @dev Transfer tokens from one address to another
122      * @param _from address The address which you want to send tokens from
123      * @param _to address The address which you want to transfer to
124      * @param _value uint256 the amount of tokens to be transferred
125      */ 
126     function transferFrom(address _from, address _to, uint _value) public returns (bool){
127         require(msg.sender != address(0));
128         require(_to != address(0));
129         require(_value > 0 && _value <= balances[_from] && _value <= allowed[_from][msg.sender]);
130         balances[_from] = balances[_from].sub(_value);
131         balances[_to] = balances[_to].add(_value);
132         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
133         emit Transfer(_from, _to, _value);
134         return true;
135     }
136  
137     /**
138      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
139      * @param _spender The address which will spend the funds.
140      * @param _value The amount of tokens to be spent.
141      */
142     function approve(address _spender, uint _value) public returns (bool){
143         allowed[msg.sender][_spender] = _value;
144         emit Approval(msg.sender, _spender, _value);
145         return true;
146     }
147  
148     /** 
149      * @dev Function to check the amount of tokens that an owner allowed to a spender.
150      * @param _owner address The address which owns the funds.
151      * @param _spender address The address which will spend the funds.
152      * @return A uint256 specifying the amount of tokens still available for the spender.
153      */
154     function allowance(address _owner, address _spender) public view returns (uint){
155         return allowed[_owner][_spender]; 
156     } 
157  
158     /**
159      * @dev Increase approved amount of tokents that could be spent on behalf of msg.sender.
160      * @param _spender The address which will spend the funds.
161      * @param _addedValue The amount of tokens to be spent.
162      */
163     function increaseApproval(address _spender, uint _addedValue) public returns (bool){
164         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
165         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]); 
166         return true; 
167     }
168  
169     /**
170      * @dev Decrease approved amount of tokents that could be spent on behalf of msg.sender.
171      * @param _spender The address which will spend the funds.
172      * @param _subtractedValue The amount of tokens to be spent.
173      */
174     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool){
175         uint oldValue = allowed[msg.sender][_spender];
176         if(_subtractedValue > oldValue){
177             allowed[msg.sender][_spender] = 0;
178         }else{
179             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
180         }
181         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
182         return true;
183     }
184 }