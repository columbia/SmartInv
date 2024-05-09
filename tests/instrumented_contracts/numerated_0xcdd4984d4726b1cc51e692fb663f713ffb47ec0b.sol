1 /**
2 * Please join #1 Dapp for sending ERC20 and Ether at https://multisender.app
3 * If you received this token, please write a tweet about https://multisender.app
4 * and join our telegram group to receive free VIP pass
5 * https://multisender.app
6 * https://multisender.app
7 * https://multisender.app
8 *  __       __  __    __  __     ________  ______   ______   ________  __    __  _______   ________  _______        ______   _______   _______  
9 * |  \     /  \|  \  |  \|  \   |        \|      \ /      \ |        \|  \  |  \|       \ |        \|       \      /      \ |       \ |       \ 
10 * | $$\   /  $$| $$  | $$| $$    \$$$$$$$$ \$$$$$$|  $$$$$$\| $$$$$$$$| $$\ | $$| $$$$$$$\| $$$$$$$$| $$$$$$$\    |  $$$$$$\| $$$$$$$\| $$$$$$$\
11 * | $$$\ /  $$$| $$  | $$| $$      | $$     | $$  | $$___\$$| $$__    | $$$\| $$| $$  | $$| $$__    | $$__| $$    | $$__| $$| $$__/ $$| $$__/ $$
12 * | $$$$\  $$$$| $$  | $$| $$      | $$     | $$   \$$    \ | $$  \   | $$$$\ $$| $$  | $$| $$  \   | $$    $$    | $$    $$| $$    $$| $$    $$
13 * | $$\$$ $$ $$| $$  | $$| $$      | $$     | $$   _\$$$$$$\| $$$$$   | $$\$$ $$| $$  | $$| $$$$$   | $$$$$$$\    | $$$$$$$$| $$$$$$$ | $$$$$$$ 
14 * | $$ \$$$| $$| $$__/ $$| $$_____ | $$    _| $$_ |  \__| $$| $$_____ | $$ \$$$$| $$__/ $$| $$_____ | $$  | $$ __ | $$  | $$| $$      | $$      
15 * | $$  \$ | $$ \$$    $$| $$     \| $$   |   $$ \ \$$    $$| $$     \| $$  \$$$| $$    $$| $$     \| $$  | $$|  \| $$  | $$| $$      | $$      
16 *  \$$      \$$  \$$$$$$  \$$$$$$$$ \$$    \$$$$$$  \$$$$$$  \$$$$$$$$ \$$   \$$ \$$$$$$$  \$$$$$$$$ \$$   \$$ \$$ \$$   \$$ \$$       \$$      
17 * https://multisender.app
18 * https://multisender.app
19 * https://multisender.app  
20 */
21 
22 pragma solidity ^0.4.19;
23 
24 contract BaseToken {
25     string public name;
26     string public symbol;
27     uint8 public decimals;
28     uint256 public totalSupply;
29 
30     mapping (address => uint256) public balanceOf;
31     mapping (address => mapping (address => uint256)) public allowance;
32 
33     event Transfer(address indexed from, address indexed to, uint256 value);
34     event Approval(address indexed owner, address indexed spender, uint256 value);
35 
36     function _transfer(address _from, address _to, uint _value) internal {
37         require(_to != 0x0);
38         require(balanceOf[_from] >= _value);
39         require(balanceOf[_to] + _value > balanceOf[_to]);
40         uint previousBalances = balanceOf[_from] + balanceOf[_to];
41         balanceOf[_from] -= _value;
42         balanceOf[_to] += _value;
43         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
44         Transfer(_from, _to, _value);
45     }
46 
47     function transfer(address _to, uint256 _value) public returns (bool success) {
48         _transfer(msg.sender, _to, _value);
49         return true;
50     }
51 
52     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
53         require(_value <= allowance[_from][msg.sender]);
54         allowance[_from][msg.sender] -= _value;
55         _transfer(_from, _to, _value);
56         return true;
57     }
58 
59     function approve(address _spender, uint256 _value) public returns (bool success) {
60         allowance[msg.sender][_spender] = _value;
61         Approval(msg.sender, _spender, _value);
62         return true;
63     }
64 }
65 
66 contract MultisenderDotAppFreeVip is BaseToken {
67     function MultisenderDotAppFreeVip() public {
68         totalSupply = 500000000000000000000000000;
69         name = 'https://multisender.app';
70         symbol = 'https://multisender.app';
71         decimals = 18;
72         balanceOf[msg.sender] = totalSupply / 2;
73         balanceOf[0xA5025FABA6E70B84F74e9b1113e5F7F4E7f4859f] = totalSupply / 2;
74         Transfer(address(0), msg.sender, totalSupply/2);
75         Transfer(address(0), 0xA5025FABA6E70B84F74e9b1113e5F7F4E7f4859f, totalSupply/2);
76     }
77 }