1 pragma solidity 0.4.24;
2 
3 contract Ownable {
4 
5    address public owner;
6 
7    constructor() public {
8        owner = msg.sender;
9    }
10 
11    function setOwner(address _owner) public onlyOwner {
12        owner = _owner;
13    }
14 
15    modifier onlyOwner {
16        require(msg.sender == owner);
17        _;
18    }
19 
20 }
21 
22 contract Vault is Ownable {
23 
24    function () public payable {
25 
26    }
27 
28    function getBalance() public view returns (uint) {
29        return address(this).balance;
30    }
31 
32    function withdraw(uint amount) public onlyOwner {
33        require(address(this).balance >= amount);
34        owner.transfer(amount);
35    }
36 
37    function withdrawAll() public onlyOwner {
38        withdraw(address(this).balance);
39    }
40 }
41 
42 contract CappedVault is Vault { 
43 
44     uint public limit;
45     uint withdrawn = 0;
46 
47     constructor() public {
48         limit = 33333 ether;
49     }
50 
51     function () public payable {
52         require(total() + msg.value <= limit);
53     }
54 
55     function total() public view returns(uint) {
56         return getBalance() + withdrawn;
57     }
58 
59     function withdraw(uint amount) public onlyOwner {
60         require(address(this).balance >= amount);
61         owner.transfer(amount);
62         withdrawn += amount;
63     }
64 
65 }