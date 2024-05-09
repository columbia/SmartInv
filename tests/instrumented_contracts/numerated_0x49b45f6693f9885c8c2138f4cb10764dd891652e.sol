1 pragma solidity ^0.4.24;
2 
3 contract Kiwiana {
4     address public owner;
5     mapping (address => uint) public payments;
6     mapping (address => string) public allergies;
7     address public chris = 0xC369B30c8eC960260631E20081A32e4c61E5Ea9d;
8 
9     constructor() public {
10         owner = msg.sender;
11     }
12 
13     modifier onlyOwner() {
14         require(msg.sender == owner);
15         _;
16     }
17 
18     function () external payable {
19         register(msg.sender);
20     }
21 
22     function register(address _attendee) public payable returns(bool) {
23         uint weiAmount = msg.value;
24         if(weiAmount >= 100000000000000000) {
25             payments[_attendee] = weiAmount;
26             return true;
27         }
28         else {
29             // you didn't pay enough, so we're just swallowing how much you spent
30             return false;
31         }
32     }
33 
34     function isEatingAndDrinking(address __attendee) public view returns(bool) {
35         if(payments[__attendee] >= 150000000000000000) {
36             return true;
37         }
38         return false;
39     }
40 
41     function isEating(address __attendee) public view returns(bool) {
42         if(payments[__attendee] >= 100000000000000000) {
43             return true;
44         }
45         return false;
46     }
47 
48     function allergy(string _description) public payable returns(bool) {
49         if(payments[msg.sender] >= 100000000000000000) {
50             // you paid so we care about your allergies
51             allergies[msg.sender] = _description;
52             return true;
53         }
54         return false;
55     }
56 
57     function giveMeBackMyMoney() public onlyOwner {
58         //send all money to chris
59         chris.transfer(address(this).balance);
60     }
61 }