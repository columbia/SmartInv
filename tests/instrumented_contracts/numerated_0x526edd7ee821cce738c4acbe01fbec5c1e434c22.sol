1 pragma solidity ^0.5.7;
2 
3 contract DepositContract {
4     MainDepositContract public _main_contract;
5     uint256 public _user_id;
6 
7     constructor(uint256 user_id) public {
8         _user_id = user_id;
9         _main_contract = MainDepositContract(msg.sender);
10     }
11 
12     function () external payable {
13         _main_contract.log_deposit.value(msg.value)(_user_id);
14     }
15 }
16 
17 contract MainDepositContract {
18     mapping (uint256 => DepositContract) public _deposit_contracts;
19     mapping (address => bool) public _owners;
20     address _management_address;
21 
22     event Deposit(uint256 _user_id, uint256 _amount);
23     event Withdraw(address payable _address, uint256 _amount);
24 
25     modifier _onlyOwners() {
26         require(_owners[msg.sender], 'Sender is not an owner');
27         _;
28     }
29 
30     modifier _onlyManager() {
31         require(_owners[msg.sender] || msg.sender == _management_address, 'Sender is nether a manager nor owner');
32         _;
33     }
34 
35     constructor() public {
36         _owners[msg.sender] = true;
37         _management_address = msg.sender;
38     }
39 
40     function add_owner(address owner_address) _onlyOwners public {
41         require(!_owners[owner_address], 'This address is already an owner');
42         _owners[owner_address] = true;
43     }
44 
45     function remove_owner(address owner_address) _onlyOwners public {
46         require(_owners[owner_address], 'This address is not an owner');
47         _owners[owner_address] = false;
48     }
49 
50     function set_management_address(address management_address) _onlyOwners public {
51         _management_address = management_address;
52     }
53 
54     function create_deposit_address(uint256 user_id) _onlyManager public returns (DepositContract created_contract) {
55         DepositContract c = new DepositContract(user_id);
56         _deposit_contracts[user_id] = c;
57         return c;
58     }
59 
60     function log_deposit(uint256 user_id) public payable {
61         require(address(_deposit_contracts[user_id]) == msg.sender, 'Sender is not a deployed deposit contract');
62         emit Deposit(user_id, msg.value);
63     }
64 
65     function withdraw(uint256 amount, address payable withdraw_to) _onlyManager public {
66         require(address(this).balance >= amount, 'Not enough balance');
67         withdraw_to.transfer(amount);
68         emit Withdraw(withdraw_to, amount);
69     }
70 }