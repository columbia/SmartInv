1 pragma solidity ^0.4.19;
2 
3 /**
4    @title HODL
5 
6    A smart contract for real HOLDERS, all ETH received here can be withdraw a year 
7    after it was deposited.
8  */
9 contract HODL {
10 
11     // 1 Year to relase the funds
12     uint256 public RELEASE_TIME = 1 years;
13 
14     // Balances on hold
15     mapping(address => Deposit) deposits;
16     
17     struct Deposit {
18         uint256 value;
19         uint256 releaseTime;
20     }
21     
22     /**
23      @dev Fallback function
24 
25      Everytime the contract receives ETH it will check if there is a deposit
26      made by the `msg.sender` if there is one the value of the tx wil be added
27      to the current deposit and the release time will be reseted adding a year
28      If there is not deposit created by the `msg.sender` it will be created.
29    */
30     function () public payable {
31         require(msg.value > 0);
32         
33         if (deposits[msg.sender].releaseTime == 0) {
34             uint256 releaseTime = now + RELEASE_TIME;
35             deposits[msg.sender] = Deposit(msg.value, releaseTime);
36         } else {
37             deposits[msg.sender].value += msg.value;
38             deposits[msg.sender].releaseTime += RELEASE_TIME;
39         }
40     }
41     
42     /**
43      @dev withdraw function
44 
45      This function can be called by a holder after a year of his last deposit
46      and it will transfer all the ETH deposited back to him.
47    */
48     function withdraw() public {
49         require(deposits[msg.sender].value > 0);
50         require(deposits[msg.sender].releaseTime < now);
51         
52         msg.sender.transfer(deposits[msg.sender].value);
53         
54         deposits[msg.sender].value = 0;
55         deposits[msg.sender].releaseTime = 0;
56     }
57     
58     /**
59      @dev getDeposit function
60      It returns the deposited value and release time from a holder.
61 
62      @param holder address The holder address
63 
64      @return uint256 value Amount of ETH deposited in wei
65      @return uint256 releaseTime Timestamp of when the the deposit can returned
66    */
67     function getDeposit(address holder) public view returns
68         (uint256 value, uint256 releaseTime)
69     {
70         return(deposits[holder].value, deposits[holder].releaseTime);
71     }
72 }