1 pragma solidity ^0.4.19;
2 contract Ownable {
3     address public owner;
4 
5 
6     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
7 
8 
9     /**
10      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
11      * account.
12      */
13     function Ownable() public {
14         owner = msg.sender;
15     }
16 
17 
18     /**
19      * @dev Throws if called by any account other than the owner.
20      */
21     modifier onlyOwner() {
22         require(msg.sender == owner);
23         _;
24     }
25 
26 
27     /**
28      * @dev Allows the current owner to transfer control of the contract to a newOwner.
29      * @param newOwner The address to transfer ownership to.
30      */
31     function transferOwnership(address newOwner) public onlyOwner {
32         require(newOwner != address(0));
33         OwnershipTransferred(owner, newOwner);
34         owner = newOwner;
35     }
36 
37 }
38 library SafeMath {
39   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
40     uint256 c = a * b;
41     assert(a == 0 || c / a == b);
42     return c;
43   }
44 
45   function div(uint256 a, uint256 b) internal pure returns (uint256) {
46     uint256 c = a / b;
47     return c;
48   }
49 
50   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
51     assert(b <= a);
52     return a - b;
53   }
54 
55   function add(uint256 a, uint256 b) internal pure returns (uint256) {
56     uint256 c = a + b;
57     assert(c >= a);
58     return c;
59   }
60 }
61 contract HHRinterface {
62     uint256 public totalSupply;
63     function balanceOf(address who) public view returns (uint256);
64     function transfer(address to, uint256 value) public returns (bool);
65     function allowance(address owner, address spender) public view returns (uint256);
66     function transferFrom(address from, address to, uint256 value) public returns (bool);
67     function approve(address spender, uint256 value) public returns (bool); 
68 }
69 contract HHRLocker is Ownable {
70     using SafeMath for uint;
71     uint lockTime;
72     uint[] frozenAmount=[7500000000000,3750000000000,1875000000000,937500000000,468750000000,234375000000,117187500000,58593750000,29296875000,0];
73     HHRinterface HHR;
74     
75     function HHRFallback(address _from, uint _value, uint _code){
76         
77     } //troll's trap
78     function getToken(uint _amount,address _to) onlyOwner {
79         uint deltaTime = now-lockTime;
80         uint yearNum = deltaTime.div(1 years);
81         if (_amount>frozenAmount[yearNum]){
82             revert();
83         }
84         else{
85             HHR.transfer(_to,_amount);
86         }        
87     }
88     function setLockTime() onlyOwner {
89         lockTime=now;
90     }
91     function HHRLocker(){
92         lockTime = now;
93     }
94     function cashOut(uint amount) onlyOwner{
95         HHR.transfer(owner,amount);
96     }
97     function setHHRAddress(address HHRAddress) onlyOwner{
98         HHR = HHRinterface(HHRAddress);
99     }
100 }