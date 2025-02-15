#include <string>
#include <iostream>

class WrongAnimal
{
	protected:
		std::string _type;

	public:
		WrongAnimal();
		WrongAnimal(const WrongAnimal &copyWronga);

		~WrongAnimal();

		WrongAnimal &operator=(const WrongAnimal &wronga);

		void makeSound(void)const;

		std::string getType(void)const;
};