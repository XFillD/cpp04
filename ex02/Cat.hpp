#include "Animal.hpp"
#include "Brain.hpp"

class Cat: public Animal
{
	private:
		Brain *_brain;

	public:
		Cat();
		Cat(const Cat &copyCat);

		~Cat();

		Cat &operator=(const Cat &cat);

		void makeSound(void)const;

		void getIdeas(void)const;

		void setIdea(size_t i, std::string idea);
};