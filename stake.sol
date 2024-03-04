// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
// parent contract
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
 //this contract is inheritting codes from ERC20 above
contract MyToken is ERC20 {
 //this takes  the address and value of the staked token
mapping(address => uint) public staked;
//this takes in the address and value of the account it is staked from
mapping(address => uint) private stakedFromTS;
 //this will be responsible for initializing the state variables which is line 4
    constructor() ERC20("MyToken", "MTK") {
        _mint(msg.sender, 10 ** 18);
    }
 //this function allows us to stake our token and it is taking input of amount
function stake(uint amount) external{
    // it requires the staked amount must be greater than o or else we get an error
require(amount >0, "amount is <=0");
//it also requires the balance of the senders acct must be greater or equal to the 
//amount the person wants to stake, else we get an error
require(balanceOf(msg.sender) >= amount, "balance is <= amount");
//this takes input of senders address,address to stake tokens to and amount to stake 
_transfer(msg.sender, address(this), amount);
 //this says if the staked address is greater than o, then it can be claimed
if(staked[msg.sender] > 0){
claim();
}
//this takes record of the acct the token was staked from and the time it was staked
stakedFromTS[msg.sender] = block.timestamp;
//this allows the owner to add more tokens to stake
staked[msg.sender] += amount;
 
}
//this function allows the owner to unstake what was previously staked and it takes input of the amount 
function unstake(uint amount) external{
 //this states the unstakedamount must be greater than 0 else we get an error msg
require(amount >0, "amount is <=0");
//it also requires that what is in the staked acct must be greater than 0, else we get an error msg 
require(staked[msg.sender] > 0, "You did not stake with us");
//this takes record of the acct of the owner unstaking and time it was unstaked
stakedFromTS[msg.sender] = block.timestamp;
//this allows the owner to deduct the amount to unstake from the staked tokens
staked[msg.sender] -= amount;
// this takes input of acct with the staked token,owners acct and amount to unstake
_transfer(address(this), msg.sender, amount);
}
// this fuction allows the owner claim the tokens after the staking period 
function claim() public {
    //this requires staked acct must be greater than 0 else we get an error msg
require(staked[msg.sender] > 0, "Staked is <= 0 ");
//this takes record of the time and address claiming the staked tokens
uint secondsStaked = block.timestamp - stakedFromTS[msg.sender];
//this gives us the reward gotten from staking the tokens which is the staked token multiplied by
//the stake period divided by 3.154e7
uint rewards = staked[msg.sender] * secondsStaked / 3.154e7;
// this takes input of staked tokens anf reward
_mint(msg.sender, rewards);
// this shows owners acct and the time the tokens was claimed
stakedFromTS[msg.sender] = block.timestamp;
 
}
   
}
 