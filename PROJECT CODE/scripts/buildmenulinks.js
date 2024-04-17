function buildMenuLinks(accesstype)
{
	console.log("building menu links for accesstype " + accesstype);
	
	// Build the appropriate menu links
	var builder = "";
	switch (parseInt(accesstype))
	{
	case 1:
		builder += '<ul class="menulinks">';
		builder += '<li><a href="FoodBankSystem.html">Main Menu</a></li>';
		builder += '<li><a href="FR4FR5.html">Modify product category quantities</a></li>';
		builder += '<li><a href="FR11FR12.html">Assemble food parcel</a></li>';
		builder += '</ul>';
		break;
	case 2:
		builder += '<ul class="menulinks">';
		builder += '<li><a href="FoodBankSystem.html">Main Menu</a></li>';
		builder += '<li><a href="FR4FR5.html">Modify product category quantities</a></li>';
		builder += '<li><a href="FR4FR6.html">Modify product category thresholds</a></li>';
		builder += '<li><a href="FR11FR12.html">Assemble food parcel</a></li>';
		builder += '</ul>';
		break;
	default:
		builder += '<ul class="menulinks">';
		builder += '<li><a href="FoodBankSystem.html">Main Menu</a></li>';
		builder += '</ul>';
		// builder += "Sorry, user not authorised.";
	}
	return builder;
}