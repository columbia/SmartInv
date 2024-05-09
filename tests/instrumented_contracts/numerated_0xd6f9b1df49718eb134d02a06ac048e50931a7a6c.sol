1 pragma solidity ^0.4.18;
2 
3 contract ZastrinPay {
4 
5   /*
6    * Author: Mahesh Murthy
7    * Company: Zastrin, Inc
8    * Contact: mahesh@zastrin.com
9    */
10 
11   address public owner;
12 
13   struct paymentInfo {
14     uint userId;
15     uint amount;
16     uint purchasedAt;
17     bool refunded;
18     bool cashedOut;
19   }
20 
21   mapping(uint => bool) coursesOffered;
22   mapping(address => mapping(uint => paymentInfo)) customers;
23 
24   uint fallbackAmount;
25 
26   event NewPayment(uint indexed _courseId, uint indexed _userId, address indexed _customer, uint _amount);
27   event RefundPayment(uint indexed _courseId, uint indexed _userId, address indexed _customer);
28 
29   modifier onlyOwner() {
30     require(msg.sender == owner);
31     _;
32   }
33 
34   function ZastrinPay() public {
35     owner = msg.sender;
36   }
37 
38   function addCourse(uint _courseId) public onlyOwner {
39     coursesOffered[_courseId] = true;
40   }
41 
42   function buyCourse(uint _courseId, uint _userId) public payable {
43     require(coursesOffered[_courseId]);
44     customers[msg.sender][_courseId].amount += msg.value;
45     customers[msg.sender][_courseId].purchasedAt = now;
46     customers[msg.sender][_courseId].userId = _userId;
47     NewPayment(_courseId, _userId, msg.sender, msg.value);
48   }
49 
50   function getRefund(uint _courseId) public {
51     require(customers[msg.sender][_courseId].userId > 0);
52     require(customers[msg.sender][_courseId].refunded == false);
53     require(customers[msg.sender][_courseId].purchasedAt + (3 hours) > now);
54     customers[msg.sender][_courseId].refunded = true;
55     msg.sender.transfer(customers[msg.sender][_courseId].amount);
56     RefundPayment(_courseId, customers[msg.sender][_courseId].userId, msg.sender);
57   }
58 
59   function cashOut(address _customer, uint _courseId) public onlyOwner {
60     require(customers[_customer][_courseId].refunded == false);
61     require(customers[_customer][_courseId].cashedOut == false);
62     require(customers[_customer][_courseId].purchasedAt + (3 hours) < now);
63     customers[_customer][_courseId].cashedOut = true;
64     owner.transfer(customers[_customer][_courseId].amount);
65   }
66 
67   function cashOutFallbackAmount() public onlyOwner {
68     owner.transfer(fallbackAmount);
69   }
70 
71   function() public payable {
72     fallbackAmount += msg.value;
73   }
74 }