1 pragma solidity ^0.4.11;
2 contract FundariaToken {
3     string public constant name = "Fundaria Token";
4     string public constant symbol = "RI";
5     
6     uint public totalSupply; // how many tokens supplied at the moment
7     uint public supplyLimit; // how many tokens can be supplied    
8     uint public course; // course wei for token
9  
10     mapping(address=>uint256) public balanceOf; // owned tokens
11     mapping(address=>mapping(address=>uint256)) public allowance; // allowing third parties to transfer tokens 
12     mapping(address=>bool) public allowedAddresses; // allowed addresses to manage some functions    
13 
14     address public fundariaPoolAddress; // ether source for Fundaria development
15     address creator; // creator address of this contract
16     
17     event SuppliedTo(address indexed _to, uint _value);
18     event Transfer(address indexed _from, address indexed _to, uint256 _value);
19     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
20     event SupplyLimitChanged(uint newLimit, uint oldLimit);
21     event AllowedAddressAdded(address _address);
22     event CourseChanged(uint newCourse, uint oldCourse);
23     
24     function FundariaToken() {
25         allowedAddresses[msg.sender] = true; // add creator address to allowed addresses
26         creator = msg.sender;
27     }
28     
29     // condition to be creator address to run some functions
30     modifier onlyCreator { 
31         if(msg.sender == creator) _; 
32     }
33     
34     // condition to be allowed address to run some functions
35     modifier isAllowed {
36         if(allowedAddresses[msg.sender]) _; 
37     }
38     
39     // set address for Fundaria source of ether
40     function setFundariaPoolAddress(address _fundariaPoolAddress) onlyCreator {
41         fundariaPoolAddress = _fundariaPoolAddress;
42     }     
43     
44     // expand allowed addresses with new one    
45     function addAllowedAddress(address _address) onlyCreator {
46         allowedAddresses[_address] = true;
47         AllowedAddressAdded(_address);
48     }
49     
50     // remove allowed address
51     function removeAllowedAddress(address _address) onlyCreator {
52         delete allowedAddresses[_address];    
53     }
54 
55     // increase token balance of some address
56     function supplyTo(address _to, uint _value) isAllowed {
57         totalSupply += _value;
58         balanceOf[_to] += _value;
59         SuppliedTo(_to, _value);
60     }
61     
62     // limit total tokens can be supplied
63     function setSupplyLimit(uint newLimit) isAllowed {
64         SupplyLimitChanged(newLimit, supplyLimit);
65         supplyLimit = newLimit;
66     }                
67     
68     // set course
69     function setCourse(uint newCourse) isAllowed {
70         CourseChanged(newCourse, course);
71         course = newCourse;
72     } 
73     
74     // token for wei according to course
75     function tokenForWei(uint _wei) constant returns(uint) {
76         return _wei/course;    
77     }
78     
79     // wei for token according to course
80     function weiForToken(uint _token) constant returns(uint) {
81         return _token*course;
82     } 
83     
84     // transfer tokens to another address (owner)    
85     function transfer(address _to, uint256 _value) returns (bool success) {
86         if (_to == 0x0 || balanceOf[msg.sender] < _value || balanceOf[_to] + _value < balanceOf[_to]) 
87             return false; 
88         balanceOf[msg.sender] -= _value;                     
89         balanceOf[_to] += _value;                            
90         Transfer(msg.sender, _to, _value);
91         return true;
92     }
93     
94     // setting of availability of tokens transference for third party
95     function transferFrom(address _from, address _to, uint256 _value) 
96         returns (bool success) {
97         if(_to == 0x0 || balanceOf[_from] < _value || _value > allowance[_from][msg.sender]) 
98             return false;                                
99         balanceOf[_from] -= _value;                           
100         balanceOf[_to] += _value;                             
101         allowance[_from][msg.sender] -= _value;
102         Transfer(_from, _to, _value);
103         return true;
104     }
105     
106     // approving transference of tokens for third party
107     function approve(address _spender, uint256 _value) 
108         returns (bool success) {
109         allowance[msg.sender][_spender] = _value;
110         Approval(msg.sender, _spender, _value);
111         return true;
112     }
113     
114     // Prevents accidental sending of ether
115     function () {
116 	    throw; 
117     }     
118          
119 }