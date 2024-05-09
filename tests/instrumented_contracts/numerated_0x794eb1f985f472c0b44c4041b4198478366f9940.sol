1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10     address public owner;
11 
12     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14     /**
15     * @dev Throws if called by any account other than the owner.
16     */
17     modifier onlyOwner() {
18         require(msg.sender == owner);
19         _;
20     }
21 
22     /**
23     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
24     * account.
25     */
26     function Ownable() public {
27         owner = msg.sender;
28     }
29 
30     /**
31     * @dev Allows the current owner to transfer control of the contract to a newOwner.
32     * @param newOwner The address to transfer ownership to.
33     */
34     function transferOwnership(address newOwner) onlyOwner public {
35         require(newOwner != address(0));
36         OwnershipTransferred(owner, newOwner);
37         owner = newOwner;
38     }
39 
40 }
41 
42 /*
43  * ERC20Basic
44  * Simpler version of ERC20 interface
45  * see https://github.com/ethereum/EIPs/issues/20
46  */
47 contract ERC20Basic {
48     function totalSupply() public constant returns (uint256);
49     function balanceOf(address _owner) public constant returns (uint256);
50     function transfer(address _to, uint256 _value) public returns (bool);
51     event Transfer(address indexed from, address indexed to, uint value);
52 }
53 
54 
55 contract ERC223Basic is ERC20Basic {
56     function transfer(address to, uint value, bytes data) public returns (bool);
57 }
58 
59 
60 /*
61  * ERC20 interface
62  * see https://github.com/ethereum/EIPs/issues/20
63  */
64 contract ERC20 is ERC223Basic {
65     // active supply of tokens
66     function allowance(address _owner, address _spender) public constant returns (uint256);
67     function transferFrom(address _from, address _to, uint _value) public returns (bool);
68     function approve(address _spender, uint256 _value) public returns (bool);
69     event Approval(address indexed owner, address indexed spender, uint256 value);
70 }
71 
72  /*
73  * Contract that is working with ERC223 tokens
74  */
75 
76 contract ERC223ReceivingContract {
77     function tokenFallback(address _from, uint _value, bytes _data) public;
78 }
79 
80 /**
81  * @title ControlCentreInterface
82  * @dev ControlCentreInterface is an interface for providing commonly used function
83  * signatures to the ControlCentre
84  */
85 contract ControllerInterface {
86 
87     function totalSupply() public constant returns (uint256);
88     function balanceOf(address _owner) public constant returns (uint256);
89     function allowance(address _owner, address _spender) public constant returns (uint256);
90     function approve(address owner, address spender, uint256 value) public returns (bool);
91     function transfer(address owner, address to, uint value, bytes data) public returns (bool);
92     function transferFrom(address owner, address from, address to, uint256 amount, bytes data) public returns (bool);
93     function mint(address _to, uint256 _amount) public returns (bool);
94 }
95 
96 contract Token is Ownable, ERC20 {
97 
98     event Mint(address indexed to, uint256 amount);
99     event MintToggle(bool status);
100 
101     // Constant Functions
102     function balanceOf(address _owner) public constant returns (uint256) {
103         return ControllerInterface(owner).balanceOf(_owner);
104     }
105 
106     function totalSupply() public constant returns (uint256) {
107         return ControllerInterface(owner).totalSupply();
108     }
109 
110     function allowance(address _owner, address _spender) public constant returns (uint256) {
111         return ControllerInterface(owner).allowance(_owner, _spender);
112     }
113 
114     function mint(address _to, uint256 _amount) onlyOwner public returns (bool) {
115         bytes memory empty;
116         _checkDestination(address(this), _to, _amount, empty);
117         Mint(_to, _amount);
118         Transfer(address(0), _to, _amount);
119         return true;
120     }
121 
122     function mintToggle(bool status) onlyOwner public returns (bool) {
123         MintToggle(status);
124         return true;
125     }
126 
127     // public functions
128     function approve(address _spender, uint256 _value) public returns (bool) {
129         ControllerInterface(owner).approve(msg.sender, _spender, _value);
130         Approval(msg.sender, _spender, _value);
131         return true;
132     }
133 
134     function transfer(address _to, uint256 _value) public returns (bool) {
135         bytes memory empty;
136         return transfer(_to, _value, empty);
137     }
138 
139     function transfer(address to, uint value, bytes data) public returns (bool) {
140         ControllerInterface(owner).transfer(msg.sender, to, value, data);
141         Transfer(msg.sender, to, value);
142         _checkDestination(msg.sender, to, value, data);
143         return true;
144     }
145 
146     function transferFrom(address _from, address _to, uint _value) public returns (bool) {
147         bytes memory empty;
148         return transferFrom(_from, _to, _value, empty);
149     }
150 
151 
152     function transferFrom(address _from, address _to, uint256 _amount, bytes _data) public returns (bool) {
153         ControllerInterface(owner).transferFrom(msg.sender, _from, _to, _amount, _data);
154         Transfer(_from, _to, _amount);
155         _checkDestination(_from, _to, _amount, _data);
156         return true;
157     }
158 
159     // Internal Functions
160     function _checkDestination(address _from, address _to, uint256 _value, bytes _data) internal {
161         uint256 codeLength;
162         assembly {
163             codeLength := extcodesize(_to)
164         }
165         if(codeLength>0) {
166             ERC223ReceivingContract untrustedReceiver = ERC223ReceivingContract(_to);
167             // untrusted contract call
168             untrustedReceiver.tokenFallback(_from, _value, _data);
169         }
170     }
171 }
172 
173 
174 /**
175  Simple Token based on OpenZeppelin token contract
176  */
177 contract Force is  Token {
178 
179     string public constant name = "Force";
180     string public constant symbol = "FORCE";
181     uint8 public constant decimals = 18;
182 
183 }