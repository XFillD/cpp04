// Includes
#include "Animal.hpp"

// classes

class Cat: public Animal
{
	private:
		// Private Members

	public:
	// Constructors
		Cat();
		Cat(const Cat &copyCat);

	// Deconstructors
		~Cat();

	// Overloaded Operators
		Cat &operator=(const Cat &cat);

	// Public Methods
		void makeSound(void)const;
	// Getter

	// Setter

};