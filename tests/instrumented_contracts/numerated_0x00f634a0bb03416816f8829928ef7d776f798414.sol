1 pragma solidity ^0.4.25;
2 contract ERC20 {
3     function balanceOf(address who) public view returns(uint);
4     function transfer(address to, uint value) public returns(bool);
5 }
6 contract KiOS {
7     address public admin;
8     mapping(address => uint) public rates;
9     event Purchase(address indexed payer, address indexed token, uint price, uint amount);
10     event Received(address indexed sender, address indexed token, uint amount);
11     event Sent(address indexed recipient, address indexed token, uint amount);
12     constructor() public {
13         admin = msg.sender;
14     }
15     modifier restrict() {
16         require(msg.sender == admin);
17         _;
18     }
19     function check(address who) internal view returns(bool) {
20         if (who != address(0) && address(this) != who) return true;
21         else return false;
22     }
23     function getBalance(address token) internal view returns(uint) {
24         if (address(0) == token) return address(this).balance;
25         else return ERC20(token).balanceOf(address(this));
26     }
27     function changeAdmin(address newAdmin) public restrict returns(bool) {
28         require(check(newAdmin));
29         admin = newAdmin;
30         return true;
31     }
32     function() public payable {
33         if (msg.value > 0) payment();
34     }
35     function payment() public payable returns(bool) {
36         require(msg.value > 0);
37         emit Received(msg.sender, address(0), msg.value);
38         return true;
39     }
40     function pay(address recipient, address token, uint amount) public restrict returns(bool) {
41         require(check(recipient) && amount > 0 && amount <= getBalance(token));
42         if (address(0) == token) recipient.transfer(amount);
43         else if (!ERC20(token).transfer(recipient, amount)) revert();
44         emit Sent(recipient, token, amount);
45         return true;
46     }
47     function setRate(address token, uint price) public restrict returns(bool) {
48         require(check(token));
49         rates[token] = price;
50         return true;
51     }
52     function buy(address token) public payable returns(bool) {
53         require(check(token) && msg.value > 0);
54         require(getBalance(token) > 0 && rates[token] > 0);
55         uint valueEther = msg.value;
56         uint valueToken = valueEther * rates[token];
57         uint stock = getBalance(token);
58         if (valueToken > stock) {
59             msg.sender.transfer(valueEther - (stock / rates[token]));
60             valueToken = stock;
61         }
62         if (!ERC20(token).transfer(msg.sender, valueToken)) revert();
63         emit Purchase(msg.sender, token, rates[token], valueToken);
64         return true;
65     }
66 }