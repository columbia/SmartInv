1 pragma solidity ^0.4.18;
2 
3 contract usingOwnership {
4   address public contract_owner;
5 
6   modifier onlyOwner() {
7     require(msg.sender == contract_owner);
8     _;
9   }
10 
11   function usingOwnership() internal {
12     contract_owner = msg.sender;
13   }
14 
15   function Withdraw(uint _amount) onlyOwner public {
16     if (_amount > this.balance)
17       _amount = this.balance;
18     contract_owner.transfer(_amount);
19   }
20 
21   function TransferOwnership(address _new_owner) onlyOwner public {
22     require(_new_owner != address(0));
23     contract_owner = _new_owner;
24   }
25 }
26 
27 contract usingCanvasBoundaries {
28   uint private g_block;
29   uint private max_max_index;
30   uint private max_block_number;
31   uint[] private halving;
32    
33   function usingCanvasBoundaries() internal {
34     g_block = block.number;
35     max_max_index = 4198401;
36     max_block_number = g_block + 3330049;
37     halving = [g_block + 16384, g_block + 81920, g_block + 770048];
38   }
39 
40   function max_index() internal view returns(uint m_index) {
41     if (block.number > max_block_number)
42       return max_max_index;
43     uint delta = block.number - g_block;
44     return delta +
45     ((block.number <= halving[0]) ? delta : halving[0] - g_block) +
46     ((block.number <= halving[1]) ? delta : halving[1] - g_block) +
47     ((block.number <= halving[2]) ? delta : halving[2] - g_block);
48   }
49 
50   function HalvingInfo() public view returns(uint genesis_block, uint[] halving_array) {
51     return (g_block, halving);
52   }
53 }
54 
55 contract Etherpixels is usingOwnership, usingCanvasBoundaries {
56   uint private starting_price = 5000000000000; /* 5000 gwei */
57 
58   /* packed to 32 bytes */
59   struct Pixel {
60     uint96 price;
61     address owner;
62   }
63   
64   mapping(uint => Pixel) private pixels;
65 
66   event PixelPainted(uint i, address new_owner, address old_owner, uint price, bytes3 new_color);
67   event PixelUnavailable(uint i, address new_owner, uint price, bytes3 new_color);
68   
69   function Paint(uint _index, bytes3 _color) public payable {
70     require(_index <= max_index());
71     paint_pixel(_index, _color, msg.value);
72   }
73 
74   function BatchPaint(uint8 _batch_size, uint[] _index, bytes3[] _color, uint[] _paid) public payable {
75     uint remaining = msg.value;
76     uint m_i = max_index();
77     for(uint8 i = 0; i < _batch_size; i++) {
78       require(remaining >= _paid[i] && _index[i] <= m_i);
79       paint_pixel(_index[i], _color[i], _paid[i]);
80       remaining -= _paid[i];
81     }
82   }
83 
84   function StartingPrice() public view returns(uint price) {
85     return starting_price;
86   }
87 
88   function LowerStartingPrice(uint _new_starting_price) onlyOwner public {
89     require(_new_starting_price < starting_price);
90     starting_price = _new_starting_price;
91   }
92   
93   function paint_pixel(uint _index, bytes3 _color, uint _paid) private {
94     Pixel storage p = pixels[_index];
95     if (msg.sender == p.owner) {
96       PixelPainted(_index, msg.sender, msg.sender, p.price, _color);
97     }
98     else {
99       uint current_price = p.price == 0 ? starting_price : uint(p.price);
100       if (_paid < current_price * 11 / 10)
101         PixelUnavailable(_index, msg.sender, current_price, _color);
102       else {
103         if (_paid > current_price * 2)
104           _paid = current_price * 2;
105         p.price = uint96(_paid);
106         require(p.price == _paid); /* casting guard */ 
107         address old_owner = p.owner;
108         p.owner = msg.sender;
109         PixelPainted(_index, msg.sender, old_owner, p.price, _color);
110         if (old_owner != address(0))
111           old_owner.send(_paid * 98 / 100); /* not using transfer to avoid old_owner locking pixel by buying it from a contract that reverts when receiving funds */
112       }
113     }
114   }
115 }