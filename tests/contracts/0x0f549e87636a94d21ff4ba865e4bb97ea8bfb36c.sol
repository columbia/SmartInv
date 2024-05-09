pragma solidity ^0.6.0;

interface Minereum {
  function BurnTokens ( uint256 mneToBurn ) external returns ( bool success );
  function CreateTokenICO (  ) payable external;
  function availableBalanceOf ( address _address ) external view returns ( uint256 Balance );
  function balanceOf ( address _address ) external view returns ( uint256 balance );
  function transfer ( address _to, uint256 _value ) external;
  function transferFrom ( address _from, address _to, uint256 _amount ) external returns ( bool success );  
}


contract MinereumLuckyDraw
{
	Minereum public mne;
	uint public stakeHoldersfee = 30;
	uint public mnefee = 0;
	uint public ethfee = 10000000000000000;
	uint public totalSentToStakeHolders = 0;
	uint public totalPaidOut = 0;
	uint public ticketsSold = 0;
	address public owner = 0x0000000000000000000000000000000000000000;
	
	constructor(address mneAddress) public
	{
		mne = Minereum(mneAddress);
		owner = payable(msg.sender);		
	}
    event Numbers(address indexed from, uint[] n, string m);
    
	uint public maxNumber = 10001;
	uint public systemNumber = 3223;
	
	receive() external payable { }
    
    function BuyTickets (uint max) public payable
    {
		uint[] memory numbers = new uint[](max);
        uint i = 0;
        bool win = false;
		
		//some sort of security to prevent miners from hacking block.timestamp. Contract Valid for 6 months.
		if (!(block.timestamp >= 1587477930 && block.timestamp <= 1603256393))
			revert('wrong timestamp');		
		
		while (i < max)
        {	
            //Random number generation
			numbers[i] = uint256(uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender, i)))%maxNumber);
            if (numbers[i] == systemNumber)
                win = true;
            i++;
        }
        
        if (win)
		{
			address payable add = payable(msg.sender);
			uint contractBalance = address(this).balance;
			emit Numbers(msg.sender, numbers, "You WON!");
			if (!add.send(contractBalance)) revert('Error While Executing Payment.');
			totalPaidOut += contractBalance;
		}
        else
		{
            emit Numbers(msg.sender, numbers, "Your numbers don't match the System Number! Try Again.");
		}
		ticketsSold += max;
		
		uint totalEthfee = ethfee * max;
		uint totalMneFee = mnefee * max;
		if (msg.value < totalEthfee) revert('Not enough ETH.');
		uint valueStakeHolder = msg.value * stakeHoldersfee / 100;
		mne.CreateTokenICO.value(valueStakeHolder)();
		totalSentToStakeHolders += valueStakeHolder;
		
		if (totalMneFee > 0)
		{
			if (!mne.transferFrom(msg.sender, address(this), totalMneFee)) revert('Not enough MNE.');
			mne.BurnTokens(totalMneFee);
		}
    }
	
	function transferFundsOut() public
	{
		if (msg.sender == owner)
		{
			address payable add = payable(msg.sender);
			uint contractBalance = address(this).balance;
			if (!add.send(contractBalance)) revert('Error While Executing Payment.');			
		}
		else
		{
			revert();
		}
	}
	
	function updateFees(uint _stakeHoldersfee, uint _mnefee, uint _ethfee) public
	{
		if (msg.sender == owner)
		{
			stakeHoldersfee = _stakeHoldersfee;
			mnefee = _mnefee;
			ethfee = _ethfee;
		}
		else
		{
			revert();
		}
	}
	
	function updateSystemNumber(uint _systemNumber) public
	{
		if (msg.sender == owner)
		{
			systemNumber = _systemNumber;
		}
		else
		{
			revert();
		}
	}
	
	function updateMaxNumber(uint _maxNumber) public
	{
		if (msg.sender == owner)
		{
			maxNumber = _maxNumber;
		}
		else
		{
			revert();
		}
	}
}