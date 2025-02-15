#include "Animal.hpp"

class Dog: public Animal
{
	public:
		Dog();
		Dog(const Dog &copyDog);

		~Dog();

		Dog &operator=(const Dog &dog);

		void makeSound(void)const;
};