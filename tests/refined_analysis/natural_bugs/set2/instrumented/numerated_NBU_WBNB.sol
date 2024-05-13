1 pragma solidity =0.8.0;
2 
3 contract NBU_WBNB {
4     string public constant name = "Nimbus Wrapped BNB";
5     string public constant symbol = "NBU_WBNB";
6     uint8  public constant decimals = 18;
7 
8     event Approval(address indexed src, address indexed guy, uint wad);
9     event Transfer(address indexed src, address indexed dst, uint wad);
10     event Deposit(address indexed dst, uint wad);
11     event Withdrawal(address indexed src, uint wad);
12 
13     mapping (address => uint) public balanceOf;
14     mapping (address => mapping (address => uint)) public allowance;
15     
16     receive() payable external {
17         deposit();
18     }
19     
20     function deposit() public payable {
21         balanceOf[msg.sender] += msg.value;
22         emit Deposit(msg.sender, msg.value);
23     }
24     
25     function withdraw(uint wad) external {
26         require(balanceOf[msg.sender] >= wad);
27         balanceOf[msg.sender] -= wad;
28         (bool success, ) = msg.sender.call{value:wad}(new bytes(0));
29         require(success, "NBU_WBNB: Transfer failed");
30         emit Withdrawal(msg.sender, wad);
31     }
32 
33     function totalSupply() external view returns (uint) {
34         return address(this).balance;
35     }
36 
37     function approve(address guy, uint wad) external returns (bool) {
38         allowance[msg.sender][guy] = wad;
39         emit Approval(msg.sender, guy, wad);
40         return true;
41     }
42 
43     function transfer(address dst, uint wad) external returns (bool) {
44         return transferFrom(msg.sender, dst, wad);
45     }
46 
47     function transferFrom(address src, address dst, uint wad) public returns (bool) {
48         require(balanceOf[src] >= wad);
49         if (src != msg.sender && allowance[src][msg.sender] != type(uint256).max) {
50             require(allowance[src][msg.sender] >= wad);
51             allowance[src][msg.sender] -= wad;
52         }
53         balanceOf[src] -= wad;
54         balanceOf[dst] += wad;
55         emit Transfer(src, dst, wad);
56         return true;
57     }    
58 }