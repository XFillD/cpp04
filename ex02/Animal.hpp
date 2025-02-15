#include <string>
#include <iostream>

class Animal
{
	protected:
		std::string _type;

	public:
		Animal();
		Animal(const Animal &copyAnimal);

		virtual ~Animal();

		Animal &operator=(const Animal &ani);

		virtual void makeSound(void)const;
		std::string getType(void)const;
};