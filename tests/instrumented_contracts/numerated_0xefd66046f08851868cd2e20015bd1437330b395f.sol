1 /* The Burner v1.0, Main-Net release.
2 *  ~by Gluedog 
3 *  -----------
4 *
5 *  Compiler version: 0.4.19+commit.c4cbbb05.Emscripten.clang
6 *
7 * The Burner is Billionaire Token's version of a "Faucet" - an evil, twisted Faucet. 
8 * Just like a Faucet, people can use it to get some extra coins. 
9 * Unlike a Faucet, the Burner will also burn coins and reduce the maximum supply in the process of giving people extra coins.
10 * The Burner is only usable by addresses who have also participated in the last week's Raffle round.
11 */
12 
13 pragma solidity ^0.4.8;
14 
15 contract XBL_ERC20Wrapper
16 {
17     function transferFrom(address from, address to, uint value) returns (bool success);
18     function transfer(address _to, uint _value) returns (bool success);
19     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
20     function burn(uint256 _value) returns (bool success);
21     function balanceOf(address _owner) constant returns (uint256 balance);
22     function totalSupply() constant returns (uint256 total_supply);
23     function burnFrom(address _from, uint256 _value) returns (bool success);
24 }
25 
26 contract XBL_RaffleWrapper
27 {
28     function getLastWeekStake(address user_addr) public returns (uint256 last_week_stake);
29     function reduceLastWeekStake(address user_addr, uint256 amount) public;
30 }
31 
32 contract TheBurner
33 {
34     uint256 DECIMALS = 1000000000000000000;
35 
36     XBL_ERC20Wrapper ERC20_CALLS;
37     XBL_RaffleWrapper RAFFLE_CALLS;
38 
39     uint8 public extra_bonus; /* The percentage of extra coins that the burner will reward people for. */
40 
41     address public burner_addr;
42     address public raffle_addr;
43     address owner_addr;
44     address XBLContract_addr;
45 
46     function TheBurner()
47     {
48         XBLContract_addr = 0x49AeC0752E68D0282Db544C677f6BA407BA17ED7;
49         raffle_addr = 0x0; /* Do we have a raffle address? */
50         extra_bonus = 5; /* 5% reward for burning your own coins, provided the burner has enough. */
51         burner_addr = address(this);
52         owner_addr = msg.sender;
53     }
54 
55     modifier onlyOwner() 
56     {
57         require (msg.sender == owner_addr);
58         _;
59     }
60 
61     function setRaffleAddress(address _raffle_addr) public onlyOwner
62     {   /* Allows the owner to set the raffle address */
63         raffle_addr = _raffle_addr;
64         RAFFLE_CALLS = XBL_RaffleWrapper(raffle_addr);
65     }
66 
67     function getPercent(uint8 percent, uint256 number) private returns (uint256 result)
68     {
69         return number * percent / 100;
70     }
71 
72     function registerBurn(uint256 user_input) returns (int8 registerBurn_STATUS)
73     {   /* This function will take a number as input, make it 18 decimal format, burn the tokens, 
74             and give them back to the user plus 5% - if he is elligible of course.
75         */
76         uint256 tokens_registered = user_input*DECIMALS; /* 18 Decimals */
77         require (ERC20_CALLS.allowance(msg.sender, burner_addr) >= tokens_registered); /* Did the user pre-allow enough tokens ? */
78         require (tokens_registered <= RAFFLE_CALLS.getLastWeekStake(msg.sender)); /* Did the user have enough tickets in last week's Raffle ? */
79         uint256 eligible_reward = tokens_registered + getPercent(extra_bonus, tokens_registered);
80         require (eligible_reward <= ERC20_CALLS.balanceOf(burner_addr)); /* Do we have enough tokens to give out? */
81 
82         /* Burn their tokens and give them their reward */
83         ERC20_CALLS.burnFrom(msg.sender, tokens_registered);
84         ERC20_CALLS.transfer(msg.sender, eligible_reward);
85 
86         /* We have to reduce the users last_week_stake so that they can't burn all of the tokens, just the ones they contributed to the Raffle. */
87         RAFFLE_CALLS.reduceLastWeekStake(msg.sender, tokens_registered);
88 
89         return 0;
90     }
91 
92 
93     /* <<<--- Debug ONLY functions. --->>> */
94     /* <<<--- Debug ONLY functions. --->>> */
95     /* <<<--- Debug ONLY functions. --->>> */
96 
97     function dSET_XBL_ADDRESS(address _XBLContract_addr) public onlyOwner
98     {/* Debugging purposes. This will be hardcoded in the deployable version. */
99         XBLContract_addr = _XBLContract_addr;
100         ERC20_CALLS = XBL_ERC20Wrapper(XBLContract_addr);
101     }
102 }