1 pragma solidity ^0.4.17;
2 
3 contract Ownable {
4     
5     address public owner;
6 
7     event OwnershipTransferred(address from, address to);
8 
9     /**
10      * The address whcih deploys this contrcat is automatically assgined ownership.
11      * */
12     function Ownable() public {
13         owner = msg.sender;
14     }
15 
16     /**
17      * Functions with this modifier can only be executed by the owner of the contract. 
18      * */
19     modifier onlyOwner {
20         require(msg.sender == owner);
21         _;
22     }
23 
24     /**
25      * Transfers ownership provided that a valid address is given. This function can 
26      * only be called by the owner of the contract. 
27      */
28     function transferOwnership(address _newOwner) public onlyOwner {
29         require(_newOwner != 0x0);
30         OwnershipTransferred(owner, _newOwner);
31         owner = _newOwner;
32     }
33 }
34 
35 library SafeMath {
36     
37     function mul(uint256 a, uint256 b) internal  returns (uint256) {
38         uint256 c = a * b;
39         assert(a == 0 || c / a == b);
40         return c;
41     }
42 
43     function div(uint256 a, uint256 b) internal returns (uint256) {
44         uint256 c = a / b;
45         return c;
46     }
47 
48     function sub(uint256 a, uint256 b) internal returns (uint256) {
49         assert(b <= a);
50         return a - b;
51     }
52 
53     function add(uint256 a, uint256 b) internal returns (uint256) {
54         uint256 c = a + b;
55         assert(c >= a);
56         return c;
57     }
58 }
59 
60 contract ShizzleNizzle {
61     function transfer(address _to, uint256 _amount) public returns(bool);
62 }
63 
64 contract AirDropSHNZ is Ownable {
65 
66     using SafeMath for uint256;
67     
68     ShizzleNizzle public constant SHNZ = ShizzleNizzle(0x8b0C9f462C239c963d8760105CBC935C63D85680);
69 
70     uint256 public rate;
71 
72     function AirDropSHNZ() public {
73         rate = 50000e8;
74     }
75 
76     function() payable {
77         buyTokens(msg.sender);
78     }
79 
80     function buyTokens(address _addr) public payable returns(bool) {
81         require(_addr != 0x0);
82         SHNZ.transfer(msg.sender, msg.value.mul(rate).div(1e18));
83         forwardFunds();
84         return true;
85     }
86 
87     function forwardFunds() internal {
88         owner.transfer(this.balance);
89     }
90 
91     function airDrop(address[] _addrs, uint256 _amount) public onlyOwner {
92         require(_addrs.length > 0);
93         for (uint i = 0; i < _addrs.length; i++) {
94             if (_addrs[i] != 0x0) {
95                 SHNZ.transfer(_addrs[i], _amount.mul(100000000));
96             }
97         }
98     }
99 
100     function issueTokens(address _beneficiary, uint256 _amount) public onlyOwner {
101         require(_beneficiary != 0x0 && _amount > 0);
102         SHNZ.transfer(_beneficiary, _amount.mul(100000000));
103     }
104 }