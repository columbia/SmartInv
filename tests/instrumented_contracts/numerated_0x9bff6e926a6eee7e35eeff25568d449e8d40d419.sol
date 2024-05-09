1 pragma solidity ^0.5.2;
2 
3 
4 contract XBL_ERC20Wrapper
5 {
6     function transferFrom(address from, address to, uint value) public returns (bool success);
7     function allowance(address _owner, address _spender) public  returns (uint256 remaining);
8     function balanceOf(address _owner) public returns (uint256 balance);
9 }
10 
11 
12 contract SwapContrak 
13 {
14     XBL_ERC20Wrapper private ERC20_CALLS;
15 
16     string eosio_username;
17     uint256 public register_counter;
18 
19     address public swap_address;
20     address public XBLContract_addr;
21 
22     mapping(string => uint256) registered_for_swap_db; 
23     mapping(uint256 => string) address_to_eosio_username;
24 
25 
26     constructor() public
27     {
28         swap_address = address(this); /* Own address */
29         register_counter = 0;
30         XBLContract_addr = 0x49AeC0752E68D0282Db544C677f6BA407BA17ED7;
31         ERC20_CALLS = XBL_ERC20Wrapper(XBLContract_addr);
32     }
33 
34     function getPercent(uint8 percent, uint256 number) private returns (uint256 result)
35     {
36         return number * percent / 100;
37     }
38     
39 
40     function registerSwap(uint256 xbl_amount, string memory eosio_username) public returns (int256 STATUS_CODE)
41     {
42         uint256 eosio_balance;
43         if (ERC20_CALLS.allowance(msg.sender, swap_address) < xbl_amount)
44             return -1;
45 
46         if (ERC20_CALLS.balanceOf(msg.sender) < xbl_amount) 
47             return - 2;
48 
49         ERC20_CALLS.transferFrom(msg.sender, swap_address, xbl_amount);
50         if (xbl_amount >= 5000000000000000000000)
51         {
52             eosio_balance = xbl_amount +getPercent(5,xbl_amount);
53         }
54         else
55         {
56             eosio_balance = xbl_amount;
57         }
58         registered_for_swap_db[eosio_username] = eosio_balance;
59         address_to_eosio_username[register_counter] = eosio_username; 
60         register_counter += 1;
61     }
62     
63     function getEOSIO_USERNAME(uint256 target) public view returns (string memory eosio_username)
64     {
65         return address_to_eosio_username[target];
66     }
67      
68     function getBalanceByEOSIO_USERNAME(string memory eosio_username) public view returns (uint256 eosio_balance) 
69     {
70         return registered_for_swap_db[eosio_username];
71     }
72 }