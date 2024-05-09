1 pragma solidity 0.5.8;
2 
3 interface IERC20 {
4     function balanceOf(address who) external view returns (uint256);
5     function transfer(address to, uint256 value) external returns (bool);
6 }
7 
8 contract Invoice {
9     address public owner;
10 
11     /**
12     * @dev Throws if called by any account other than the owner.
13     */
14     modifier onlyOwner() {
15         require(msg.sender == owner);
16         _;
17     }
18 
19     constructor(address _owner) public {
20         owner = _owner;
21     }
22     
23     function reclaimToken(IERC20 _token) external onlyOwner {
24         uint256 balance = _token.balanceOf(address(this));
25         _token.transfer(owner, balance);
26     }
27 }
28 
29 contract InvoiceCreator {
30     using SafeMath for uint;
31     
32     address public manager;
33     
34     modifier onlyManager() {
35         require(msg.sender == manager);
36         _;
37     }
38     
39     constructor(address _manager) public {
40         manager = _manager;
41     }
42     
43     // id => invoice
44     mapping(uint => address) public invoices;
45     
46     // id => initiator
47     mapping(uint => address) public initiators;
48     
49     uint public counter;
50     
51     function getInvoice() public onlyManager {
52         Invoice newInv = new Invoice(manager);
53         
54         counter = counter.add(1);
55         
56         invoices[counter] = address(newInv);
57         initiators[counter] = msg.sender;
58     }
59     
60     function getCounter() public view returns(uint) {
61         return counter;
62     }
63     
64     function getInvoiceAddr(uint id) public view returns(address) {
65         return invoices[id];
66     }
67     
68     function getInitiatorAddr(uint id) public view returns(address) {
69         return initiators[id];
70     }
71     
72     function changeManager(address _manager) public onlyManager {
73         require(_manager != address(0));
74         
75         manager = _manager;
76     }
77     
78 }
79 
80 /**
81  * @title SafeMath
82  * @dev Math operations with safety checks that throw on error
83  */
84 library SafeMath {
85 
86     /**
87     * @dev Adds two numbers, throws on overflow.
88     */
89     function add(uint256 a, uint256 b) internal pure returns (uint256) {
90         uint256 c = a + b;
91         assert(c >= a);
92         return c;
93     }
94 }