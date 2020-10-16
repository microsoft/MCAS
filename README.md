
This project has adopted the [Microsoft Open Source Code of Conduct](http://microsoft.github.io/codeofconduct). For more information see the [Code of Conduct FAQ](http://microsoft.github.io/codeofconduct/faq.md) or contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments. 



# MCAS Powershell Module [Unofficial]

Welcome to the Unofficial Microsoft Cloud App Security PowerShell module! 

This module is a collection of easy-to-use cmdlets and functions designed to make it easy to interface with the Microsoft Cloud App Security product.

Why is it unofficial, you ask? Even though this module was designed by Microsoft employees, it is NOT a formal part of the MCAS product and you will not be able to get support through standard Microsoft channels. That said, if you have problems or questions, please open an issue here on this Github repo. The authors will be more than happy to help. 


## Prerequisites

To get value from this module you must...

```
...have PowerShell v5+ (comes standard on Windows 10)
...be licensed for Microsoft Cloud App Security
...have permissions within MCAS to generate API tokens
```

## Getting Started

To get started with the module, open your PowerShell terminal as an administrator and install the module from the PSGallery by running this simple command:
```
Install-Module MCAS
```
If this is your first time installing a module, you will get prompted to install the Nuget Package Provider. Nuget is the Package/Module manager used by the PSGallery repository.

Once the module is installed, we recommend reading the wiki which will walk you through generating your API token, running your first commands, and explaining the steps to creating a stored credential file for easy scripting.


## Contributing

Apologies, we are not currently opening up this project for contribution outside of our existing team. This may change in the future if there is enough interest.

## Versioning

We use the [SemVer](http://semver.org/) scheme for versioning. 

## Authors

* **Mike Kassis** - *Co-Lead Dev* - [Github](https://github.com/Javanite), [LinkedIn](https://www.linkedin.com/in/mrkassis)
* **Jared Poeppelman** - *Co-Lead Dev* - [Github](https://github.com/powershellshock), [LinkedIn](https://www.linkedin.com/in/jaredpoeppelman/)
* **Dan Edwards** - *Dev* - [Github](https://github.com/dan-edwards), [LinkedIn](https://www.linkedin.com/in/daniel-edwards-a54892101/)
* **Anisha Gupta** - *Test design* - [LinkedIn](https://linkedin.com)

See also the list of [contributors](https://github.com/Microsoft/MCAS/graphs/contributors) who participated in this project.

## License

This project has adopted the [Microsoft Open Source Code of Conduct](http://microsoft.github.io/codeofconduct). For more information see the [Code of Conduct FAQ](http://microsoft.github.io/codeofconduct/faq.md) or contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments. 

## Acknowledgments

* Microsoft C+Ai CxE Security engineering team for testing.
* All the customers who have provided great feedback.
* Niv & Team for providing such a robust API and building such an awesome product!
* Security Global Black Belt (GBB) team and Cybersecurity Solutions Group (CSG)

